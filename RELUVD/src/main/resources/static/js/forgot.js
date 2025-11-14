let countdown;
let otpAlreadyVerified = false;

// Send OTP to Email
function sendForgotPasswordOtp() {
  const emailInput = document.querySelector('input[name="email"]');
  const email = emailInput.value.trim();
  const errorSpan = document.querySelector(".otp-error-global");

  if (!email) {
    errorSpan.textContent = "Please enter your registered email.";
    return;
  }

  fetch(`${BASE_URL}/send-reset-otp`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ to: email })
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        document.getElementById("otpSection").style.display = "block";
        errorSpan.textContent = "";
        resetOtpInputs();
        startOtpTimer();
        initializeOtpInputs();
      } else {
        errorSpan.textContent = data.message || "Failed to send OTP.";
      }
    })
    .catch(err => {
      console.error("Error:", err);
      errorSpan.textContent = "An error occurred. Try again.";
    });
}

// Reset OTP inputs
function resetOtpInputs() {
  const otpInputs = document.querySelectorAll('.otp-input');
  otpInputs.forEach(input => input.value = "");
}

// Start countdown timer for resend
function startOtpTimer() {
  let timer = 30;
  const timerDisplay = document.getElementById("timer");
  const resendBtn = document.getElementById("resendBtn");

  resendBtn.disabled = true;
  clearInterval(countdown);

  countdown = setInterval(() => {
    if (timer <= 0) {
      clearInterval(countdown);
      resendBtn.disabled = false;
      timerDisplay.textContent = "00:00";
    } else {
      timerDisplay.textContent = `00:${timer < 10 ? "0" + timer : timer}`;
      timer--;
    }
  }, 1000);
}

// Verify the entered OTP
async function verifyOtp() {
  if (otpAlreadyVerified) return true;

  const form = document.getElementById("forgotPasswordForm");
  const email = form.querySelector('input[name="email"]').value.trim();
  const otpInputs = form.querySelectorAll('.otp-input');
  const otpSection = document.getElementById("otpSection");
  const otpErrorGlobal = form.querySelector('.otp-error-global');
  const otpErrorInline = form.querySelector('.otp-error');

  otpErrorGlobal.textContent = "";
  otpErrorInline.textContent = "";

  const isVisible = window.getComputedStyle(otpSection).display !== "none";
  if (!isVisible) {
    otpErrorGlobal.textContent = "Please click 'Send OTP' and verify it.";
    return false;
  }

  const otp = Array.from(otpInputs).map(i => i.value.trim()).join("");
  const anyEmpty = Array.from(otpInputs).some(input => input.value.trim() === "");

  if (otp.length !== 4 || anyEmpty) {
    otpErrorInline.textContent = "Enter the 4-digit OTP";
    return false;
  }

  try {
    const res = await fetch(`${BASE_URL}/verify-otp`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, otp })
    });

    const data = await res.json();
    if (data.success) {
      otpAlreadyVerified = true;
      otpErrorInline.textContent = "";
      otpErrorGlobal.textContent = "";
      document.getElementById("newPassSection").style.display = "block";
      document.getElementById("confirmPassSection").style.display = "block";
      document.getElementById("resetBtn").style.display = "block";
      document.getElementById("verifyOtpBtn").disabled = true;
      return true;
    } else {
      otpErrorInline.textContent = "Invalid OTP";
      return false;
    }
  } catch (err) {
    console.error("OTP verification error:", err);
    otpErrorInline.textContent = "Error verifying OTP";
    return false;
  }
}

// Password field validation
function validatePasswordField(input, errorSpan) {
  const val = input.value.trim();
  if (!val) {
    errorSpan.textContent = "Password is required";
    return false;
  } else if (val.length < 8) {
    errorSpan.textContent = "Password must be at least 8 characters";
    return false;
  } else if (/\s/.test(val)) {
    errorSpan.textContent = "Password must not contain spaces";
    return false;
  } else if (!/[A-Za-z]/.test(val) || !/[0-9]/.test(val)) {
    errorSpan.textContent = "Password must be alphanumeric";
    return false;
  } else if (!/[!@#$%^&*]/.test(val)) {
    errorSpan.textContent = "Include a special character";
    return false;
  }
  errorSpan.textContent = "";
  return true;
}

// Confirm password match validation
function validateConfirmPasswordField(passInput, confirmInput, errorSpan) {
  const pass = passInput.value.trim();
  const confirm = confirmInput.value.trim();
  if (!confirm) {
    errorSpan.textContent = "Confirm Password is required";
    return false;
  } else if (pass !== confirm) {
    errorSpan.textContent = "Passwords do not match";
    return false;
  }
  errorSpan.textContent = "";
  return true;
}

// Validate both fields
function validateForgotPasswordFields() {
  const newPass = document.querySelector('input[name="newPassword"]');
  const confirmPass = document.querySelector('input[name="confirmPassword"]');
  const newPassError = document.querySelector('.new-pass-error');
  const confirmPassError = document.querySelector('.confirm-pass-error');

  const valid1 = validatePasswordField(newPass, newPassError);
  const valid2 = validateConfirmPasswordField(newPass, confirmPass, confirmPassError);

  return valid1 && valid2;
}

// Submit new password
function submitNewPassword() {
  const email = document.querySelector('input[name="email"]').value.trim();
  const newPassword = document.querySelector('input[name="newPassword"]').value.trim();

  if (!otpAlreadyVerified) {
    showPopup("Please verify the OTP before resetting password.", "error");
    return;
  }

  if (!validateForgotPasswordFields()) return;

  fetch(`${BASE_URL}/reset-password`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, newPassword })
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        showPopup("Password reset successful! Redirecting to login...", "success");
        setTimeout(() => {
          window.location.href = `${BASE_URL}/login`;
        }, 1500);
      } else {
        showPopup(data.message || "Password reset failed.", "error");
      }
    })
    .catch(err => {
      console.error("Error resetting password:", err);
      showPopup("An error occurred while resetting the password.", "error");
    });
}

// OTP input navigation
function initializeOtpInputs() {
  const otpInputs = document.querySelectorAll('.otp-input');
  if (!otpInputs.length) return;

  otpInputs.forEach((input, index) => {
    input.addEventListener('input', () => {
      if (input.value.length === 1 && index < otpInputs.length - 1) {
        otpInputs[index + 1].focus();
      }
    });

    input.addEventListener('keydown', e => {
      if (e.key === 'Backspace' && !input.value && index > 0) {
        otpInputs[index - 1].focus();
      }
    });

    input.addEventListener('paste', e => {
      e.preventDefault();
      const pasteData = e.clipboardData.getData('text').slice(0, otpInputs.length);
      pasteData.split('').forEach((char, i) => {
        if (otpInputs[i]) {
          otpInputs[i].value = char;
        }
      });
      if (pasteData.length === otpInputs.length) {
        otpInputs[otpInputs.length - 1].focus();
      } else {
        otpInputs[pasteData.length]?.focus();
      }
    });
  });
}

// Toggle password visibility
function togglePassword(icon) {
  const input = icon.previousElementSibling;
  const type = input.getAttribute("type");
  input.setAttribute("type", type === "password" ? "text" : "password");
  icon.classList.toggle("fa-eye-slash");
}

// Show popup
function showPopup(message, type = "info") {
  const popup = document.createElement("div");
  popup.className = `custom-popup ${type}`;
  popup.textContent = message;
  document.body.appendChild(popup);

  setTimeout(() => popup.classList.add("show"), 100);
  setTimeout(() => {
    popup.classList.remove("show");
    setTimeout(() => popup.remove(), 500);
  }, 3000);
}
document.addEventListener("DOMContentLoaded", () => {
  const newPass = document.querySelector('input[name="newPassword"]');
  const confirmPass = document.querySelector('input[name="confirmPassword"]');

  const newPassError = document.querySelector('.new-pass-error');
  const confirmPassError = document.querySelector('.confirm-pass-error');
  [newPass, confirmPass].forEach(input => {
    input.addEventListener("focus", () => {
      input.dataset.touched = "true";
    });

    input.addEventListener("blur", () => {
      if (input.dataset.touched === "true") {
        if (input.name === "newPassword") {
          validatePasswordField(newPass, newPassError);
        } else if (input.name === "confirmPassword") {
          validateConfirmPasswordField(newPass, confirmPass, confirmPassError);
        }
      }
    });
  });
});
