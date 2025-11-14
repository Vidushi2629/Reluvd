let otpAlreadyVerified = false;
let registerCountdown;
let forgotCountdown;

// Tagline animation
const taglines = [
  "Style bhi, savings bhi!",
  "Fashion that doesn’t cost the Earth!",
  "Thoda Used, Zyada Cool!",
  "Give clothes a second life!",
  "Fashion that fits your wallet!",
  "Smart fashion, smarter prices!",
  "Premium style, thrifted price!",
  "Style doesn’t have to be expensive!",
  "Every piece deserves one more chapter!",
  "Not just used — lived in, loved, and ready again!",
  "Style with a story!",
  "Reimagining wardrobes, sustainably!",
  "Your trash could be someone else's treasure!"
];

let tagIndex = 0, charIndex = 0;
const taglineDiv = document.getElementById("tagline");

function typeTagline() {
  if (charIndex < taglines[tagIndex].length) {
    taglineDiv.textContent += taglines[tagIndex].charAt(charIndex++);
    setTimeout(typeTagline, 50);
  } else {
    setTimeout(() => {
      taglineDiv.textContent = "";
      tagIndex = (tagIndex + 1) % taglines.length;
      charIndex = 0;
      typeTagline();
    }, 2000);
  }
}
typeTagline();

// Password toggle
function togglePassword(icon) {
  const input = icon.previousElementSibling;
  input.type = input.type === "password" ? "text" : "password";
  icon.classList.toggle("fa-eye");
  icon.classList.toggle("fa-eye-slash");
}

// Form switch
function toggleForm() {
  const formBox = document.getElementById('formBox');
  const loginForm = document.getElementById('loginForm');
  const registerForm = document.getElementById('registerForm');

  formBox.classList.toggle('sign-up-mode');
  const isSignUp = formBox.classList.contains('sign-up-mode');

  loginForm.style.display = isSignUp ? "none" : "block";
  registerForm.style.display = isSignUp ? "block" : "none";
}

// Validators
function validateEmailField(email, error) {
  const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const value = email.value.trim();
  if (!value) {
    error.textContent = "Email is required";
    return false;
  } else if (!pattern.test(value)) {
    error.textContent = "Enter a valid email";
    return false;
  }
  error.textContent = "";
  return true;
}

function validatePasswordField(password, error) {
  const val = password.value;
  if (!val) {
    error.textContent = "Password is required";
    return false;
  } else if (val.length < 8) {
    error.textContent = "Password must be at least 8 characters";
    return false;
  } 	else if (/\s/.test(val)) {
	   error.textContent = "Password must not contain spaces";
	   return false;
	 } 
  else if (!/[A-Za-z]/.test(val) || !/[0-9]/.test(val)) {
    error.textContent = "Password must be alphanumeric";
    return false;
  } else if (!/[!@#$%^&*]/.test(val)) {
    error.textContent = "Include a special character";
    return false;
  }
  error.textContent = "";
  return true;
}

function validateConfirmPasswordField(passwordInput, confirmInput, errorSpan) {
  const password = passwordInput.value.trim();
  const confirmPassword = confirmInput.value.trim();

  if (!confirmPassword) {
    errorSpan.textContent = "Confirm Password is required";
    return false;
  } else if (password !== confirmPassword) {
    errorSpan.textContent = "Passwords do not match";
    return false;
  }
  errorSpan.textContent = "";
  return true;
}

function validatePhoneField(phone, error) {
  const val = phone.value.trim();
  if (!val) {
    error.textContent = "Phone number is required";
    return false;
  } else if (!/^\d{10}$/.test(val)) {
    error.textContent = "Enter valid 10-digit number";
    return false;
  }
  error.textContent = "";
  return true;
}

// OTP

async function sendOtp() {
  const form = document.getElementById("registerForm");
  const email = form.querySelector('input[name="email"]');
  const emailError = form.querySelector('.register-email-error');
  const otpSection = document.getElementById("otpSection");
  const otpInputs = form.querySelectorAll('.otp-input');
  const otpErrorGlobal = form.querySelector('.otp-error-global');

  otpErrorGlobal.textContent = "";
  if (!validateEmailField(email, emailError)) return;

  try {
  const res = await fetch(`${BASE_URL}/sendemail`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ to: email.value.trim() })
    });

    const data = await res.json();

    if (data.success) {
      otpSection.style.display = "block";
	  initializeOtpInputs();
      otpInputs.forEach(input => input.value = "");
      otpAlreadyVerified = false;
	  startOtpTimer("register"); // call separate timer logic
    } else {
      emailError.textContent = "Email already registered.";
    }
  } catch {
    emailError.textContent = "Error sending OTP.";
  }
}


function startOtpTimer(context = "register") {
  let resendBtn, timer;

  if (context === "register") {
    resendBtn = document.getElementById("resendBtn");
    timer = document.getElementById("timer");
    if (registerCountdown) clearInterval(registerCountdown);
  } else if (context === "forgot") {
    resendBtn = document.getElementById("forgotResendBtn");
    timer = document.getElementById("forgotTimer");
    if (forgotCountdown) clearInterval(forgotCountdown);
  }

  if (!resendBtn || !timer) {
    console.error("Resend button or timer element not found:", resendBtn, timer);
    return;
  }

  let timeLeft = 30;
  resendBtn.disabled = true;
  timer.textContent = `00:${timeLeft < 10 ? '0' + timeLeft : timeLeft}`;

  const countdownRef = setInterval(() => {
    timeLeft--;
    timer.textContent = `00:${timeLeft < 10 ? '0' + timeLeft : timeLeft}`;

    if (timeLeft <= 0) {
      clearInterval(countdownRef);
      resendBtn.disabled = false;
      timer.textContent = "00:00";
    }
  }, 1000);

  if (context === "register") {
    registerCountdown = countdownRef;
  } else {
    forgotCountdown = countdownRef;
  }
}

async function verifyOtp() {
  if (otpAlreadyVerified) return true;

  const form = document.getElementById("registerForm");
  const email = form.querySelector('input[name="email"]').value.trim();
  const otpInputs = form.querySelectorAll('.otp-input');
  const otpSection = document.getElementById("otpSection");
  const otpErrorGlobal = form.querySelector('.otp-error-global');
  const otpErrorInline = form.querySelector('.otp-error');

  otpErrorGlobal.textContent = "";
  otpErrorInline.textContent = "";

  const isOtpSectionVisible = window.getComputedStyle(otpSection).display !== "none";
  if (!isOtpSectionVisible) {
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

      return true;
    } else {
      otpErrorInline.textContent = "Invalid OTP";
      return false;
    }
  } catch {
    otpErrorInline.textContent = "Error verifying OTP";
    return false;
  }
}


// Enable Sign Up button only if all valid
async function validateForm() {
  const form = document.getElementById("registerForm");
  const email = form.querySelector('input[name="email"]');
  const phone = form.querySelector('input[name="phone"]');
  const password = form.querySelector('input[name="password"]');
  const confirm = form.querySelector('input[name="confirmPassword"]');

  const emailError = form.querySelector('.register-email-error');
  const phoneError = form.querySelector('.phone-error');
  const passError = form.querySelector('.register-password-error');
  const confirmError = form.querySelector('.confirm-error');
  const otpErrorGlobal = form.querySelector('.otp-error-global');

  const e = validateEmailField(email, emailError);
  const p = validatePhoneField(phone, phoneError);
  const pa = validatePasswordField(password, passError);
  const c = validateConfirmPasswordField(password, confirm, confirmError);
  const o = await verifyOtp();

  const allValid = e && p && pa && c && o;

  
  return allValid;
}

// Show custom popup
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

document.querySelectorAll('#registerForm input').forEach(input => {
  input.addEventListener("focus", () => {
    input.dataset.touched = "true";
  });

  input.addEventListener("blur", () => {
    if (input.dataset.touched === "true") {
      const form = document.getElementById("registerForm");

      const email = form.querySelector('input[name="email"]');
      const phone = form.querySelector('input[name="phone"]');
      const password = form.querySelector('input[name="password"]');
      const confirm = form.querySelector('input[name="confirmPassword"]');

      const emailError = form.querySelector('.register-email-error');
      const phoneError = form.querySelector('.phone-error');
      const passError = form.querySelector('.register-password-error');
      const confirmError = form.querySelector('.confirm-error');

      // Individual validation based on field name
      switch (input.name) {
        case "email":
          validateEmailField(email, emailError);
          break;
        case "phone":
          validatePhoneField(phone, phoneError);
          break;
        case "password":
          validatePasswordField(password, passError);
          break;
        case "confirmPassword":
          validateConfirmPasswordField(password, confirm, confirmError);
          break;
      }
    }
  });
});

// Submit handler for register form
document.getElementById("registerForm").addEventListener("submit", async (e) => {
  e.preventDefault();
  const isValid = await validateForm();
  if (isValid) {
    const form = e.target;
    const formData = new FormData(form);
    const emailError = form.querySelector('.register-email-error');
    const phoneError = form.querySelector('.phone-error');
    const passError = form.querySelector('.register-password-error');
    const confirmError = form.querySelector('.confirm-error');
    const otpErrorGlobal = form.querySelector('.otp-error-global');

    try {
      const res = await fetch(`${BASE_URL}/register`, {
        method: "POST",
        body: formData
      });
      const data = await res.json();

      if (data.success) {
        showPopup("Registration successful!", "success");

        // Clear register form
        form.reset();
        otpAlreadyVerified = false;
        document.getElementById("otpSection").style.display = "none";
        emailError.textContent = "";
        phoneError.textContent = "";
        passError.textContent = "";
        confirmError.textContent = "";
        otpErrorGlobal.textContent = "";
        form.querySelectorAll('.otp-input').forEach(input => input.value = "");
        form.querySelectorAll('input').forEach(i => i.removeAttribute('data-touched'));

        // Switch to login form and reset 
        setTimeout(() => {
          toggleForm();
          const loginForm = document.getElementById("loginForm");
          loginForm.reset();
          loginForm.querySelector('.email-error').textContent = "";
          loginForm.querySelector('.password-error').textContent = "";
        }, 1500);
      } else {
        showPopup(data.message || "Registration failed", "error");
      }
    } catch {
      showPopup("Server error", "error");
    }
  }
});
/*
document.getElementById("loginForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const form = e.target;
  const email = form.querySelector('input[name="email"]');
  const password = form.querySelector('input[name="password"]');
  const emailError = form.querySelector('.email-error');
  const passError = form.querySelector('.password-error');

  // Basic field validation
  const isValid = validateEmailField(email, emailError) && validatePasswordField(password, passError);
  if (!isValid) return;

  // DB-level check using /check-login endpoint
  try {
   fetch(`${BASE_URL}/check-login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: email.value.trim(),
        password: password.value.trim()
      })
    });
	console.log(response);
    const data = await response.json();
    if (data.success) {
      window.location.href = "/home"; // ✅ Redirect to homepage
    } else {
      emailError.textContent = "";
      passError.textContent = "";
      if (data.message.includes("Email")) {
        emailError.textContent = data.message;
      } else {
        passError.textContent = data.message;
      }
    }
  } catch (err) {
    passError.textContent = "Server error. Please try again.";
  }
});
*/

// Focus and blur validation for login form
document.querySelectorAll('#loginForm input').forEach(input => {
  input.addEventListener("focus", () => {
    input.dataset.touched = "true";
  });

  input.addEventListener("blur", () => {
    if (input.dataset.touched === "true") {
      const form = document.getElementById("loginForm");
      const email = form.querySelector('input[name="email"]');
      const password = form.querySelector('input[name="password"]');
      const emailError = form.querySelector('.email-error');
      const passError = form.querySelector('.password-error');

      if (input.name === "email") {
        validateEmailField(email, emailError);
      } else if (input.name === "password") {
        validatePasswordField(password, passError);
      }
    }
  });
});


// OTP Input Auto Navigation
function initializeOtpInputs() {
  const otpInputs = document.querySelectorAll('.otp-input');
  if (!otpInputs || otpInputs.length === 0) return;

  otpInputs.forEach((input, index) => {
    input.addEventListener('input', () => {
      if (input.value.length === 1 && index < otpInputs.length - 1) {
        otpInputs[index + 1].focus();
      }
    });

    input.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && !input.value && index > 0) {
        otpInputs[index - 1].focus();
      }
    });

    input.addEventListener('paste', (e) => {
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
        otpInputs[pasteData.length].focus();
      }
    });
  });
}
async function submitLogin(event) {
  event.preventDefault(); 

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();

  const emailError = document.querySelector('.email-error');
  const passError = document.querySelector('.password-error');

  // Clear old errors
  emailError.textContent = "";
  passError.textContent = "";

  if (!validateEmailField({ value: email }, emailError) || 
      !validatePasswordField({ value: password }, passError)) {
    return;
  }

  encryptAndSubmit();

  const encryptedEmail = document.getElementById("encryptedEmail").value.trim();
  const encryptedPassword = document.getElementById("encryptedPassword").value.trim();

  try {
    const response = await fetch(`${BASE_URL}/check-login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        email: encryptedEmail,
        password: encryptedPassword
      })
    });

    const result = await response.json();

	if (result.success) {
	  window.location.href = result.redirect;
	} else {
	  if (result.message.includes("Account deactivated")) {
	    // Set the error message
	    passError.textContent = result.message;

	    // Hide Login button and show Reactivate button
	    document.getElementById("loginBtn").style.display = "none";
	    document.getElementById("reactivateBtn").style.display = "inline-block";
	  } else {
	    // Other errors (normal flow)
	    if (result.message.includes("Email")) {
	      emailError.textContent = result.message;
	    } else {
	      passError.textContent = result.message;
	    }

	    // Reset buttons to default state
	    document.getElementById("loginBtn").style.display = "inline-block";
	    document.getElementById("reactivateBtn").style.display = "none";
	  }
	}

  } catch (err) {
    passError.textContent = "Something went wrong. Please try again.";
    console.error("Login error:", err);
  }
}
/*
	function encryptAndSubmit() {
	    // Inject publicKey using JSP EL (must be base64 string)
	    const base64Key = 	"${publicKey}";

	    // Format the key into PEM format
	    const publicKeyPEM = "-----BEGIN PUBLIC KEY-----\n" +
	        base64Key.match(/.{1,64}/g).join('\n') +
	        "\n-----END PUBLIC KEY-----";
	    console.log(publicKeyPEM);

	    const encryptor = new JSEncrypt();
	    encryptor.setPublicKey(publicKeyPEM);
	    
	    document.getElementById("encryptedEmail").value = encryptor.encrypt(document.getElementById("email").value);
	    document.getElementById("encryptedPassword").value = encryptor.encrypt(document.getElementById("password").value);

	}
*/
function encryptAndSubmit() {
    if (!publicKey || publicKey === "null") {
        console.error("Public key not available");
        return;
    }

    const publicKeyPEM = "-----BEGIN PUBLIC KEY-----\n" +
        publicKey.match(/.{1,64}/g).join('\n') +
        "\n-----END PUBLIC KEY-----";

    const encryptor = new JSEncrypt();
    encryptor.setPublicKey(publicKeyPEM);

    const encryptedEmail = encryptor.encrypt(document.getElementById("email").value);
    const encryptedPassword = encryptor.encrypt(document.getElementById("password").value);

    if (!encryptedEmail || !encryptedPassword) {
        console.error("Encryption failed");
        return;
    }

    document.getElementById("encryptedEmail").value = encryptedEmail;
    document.getElementById("encryptedPassword").value = encryptedPassword;
}

