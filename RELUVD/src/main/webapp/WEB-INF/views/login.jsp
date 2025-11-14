<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ReLuvd | Login & Sign Up</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous" referrerpolicy="no-referrer"/>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header class="custom-header">
    <div style="display: flex; align-items: center;">
        <img src="${pageContext.request.contextPath}/images/reluvd-logo.png" alt="ReLuvd Logo" class="logo"/>
        <div class="brand-text">
            <h1>ReLuvd </h1>
            <p>Because OLD is the new NEW!</p>
        </div>
    </div>
</header>

<div class="moving-taglines" id="tagline"></div>

<div class="container">
    <div class="form-box" id="formBox">
        <div class="form-side">

            <!-- Login Form -->
			<form class="form login-form" id="loginForm" novalidate>

				
                <h2>Login</h2>
		
                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" placeholder="Email" required/>
                </div>
                <span class="error-message email-error"></span>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Password" required/>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword(this)"></i>
                </div>
                <span class="error-message password-error"></span>
				<input type="hidden" id="encryptedEmail">
				<input type="hidden" id="encryptedPassword">
                
				<!--<button class="btn" type="button" onclick="submitLogin(event)">Login</button>-->
				<!-- LOGIN BUTTON -->
				<button type="button" class="btn"
				        onclick="submitLogin(event)"
				        id="loginBtn"
				        style="${reactivate ? 'display:none;' : ''}">
				    Login
				</button>

				<!-- REACTIVATE BUTTON -->
				<button type="button" class="btn"
				        onclick="reactivateAccount()"
				        id="reactivateBtn"
				        style="${reactivate ? '' : 'display:none;'}">
				    Reactivate Account
				</button>






                <p class="toggle-text">Don't have an account?
                    <button type="button" onclick="toggleForm()">Sign Up</button>
                </p>
				<p class="forgot-password"><a href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a></p>

            </form>

            <!-- Register Form -->
            <form class="form register-form" id="registerForm" method="post" action="register" style="display: none;" novalidate>
                <h2>Register</h2>

                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="Email" required/>
                </div>
                <span class="error-message register-email-error"></span>

                <button type="button" class="btn" onclick="sendOtp()">Send OTP</button>
				<span class="error-message otp-error-global" style="color: red;"></span>
                <div class="otp-wrapper" id="otpSection" style="display: none;">
                    <p class="otp-instruction">Enter the 4-digit OTP sent to your email:</p>
                    <div class="otp-boxes">
                        <input type="text" maxlength="1" class="otp-input"/>
                        <input type="text" maxlength="1" class="otp-input"/>
                        <input type="text" maxlength="1" class="otp-input"/>
                        <input type="text" maxlength="1" class="otp-input"/>
                    </div>
                    <span class="error-message otp-error"></span>
                    <div class="timer-container">
                        <span id="timer">00:30</span>
                        <button type="button" id="resendBtn" onclick="sendOtp()" disabled>Resend OTP</button>
                    </div>
                </div>

                <div class="input-field">
                    <i class="fas fa-phone"></i>
                    <input type="text" name="phone" placeholder="Phone Number" required/>
                </div>
                <span class="error-message phone-error"></span>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Password" required/>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword(this)"></i>
                </div>
                <span class="error-message register-password-error"></span>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="confirmPassword" placeholder="Confirm Password" required/>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword(this)"></i>
                </div>
                <span class="error-message confirm-error"></span>

				
				<button  class="btn" id="signupBtn" type="submit">Sign Up</button>


                <p class="toggle-text">Already have an account?
                    <button type="button" onclick="toggleForm()">Sign In</button>
                </p>
            </form>
        </div>

        <div class="image-side">
            <img src="${pageContext.request.contextPath}/images/fashion-illustration.jpg" alt="Fashion Illustration"/>
        </div>
    </div>
</div>

<footer class="custom-footer">
    &copy; 2025 ReLuvd. All rights reserved.
</footer>

<!-- JS File -->
<script>
  const BASE_URL = "${pageContext.request.contextPath}";
  const publicKey = "${publicKey}";
  function reactivateAccount() {
      fetch(BASE_URL + '/reactivate', {
          method: 'POST',
          credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              alert("Account reactivated. Please log in.");
              window.location.href = BASE_URL + "/login";
          } else {
              alert(data.message || "Something went wrong.");
          }
      })
      .catch(err => {
          console.error(err);
          alert("Failed to reactivate.");
      });
  }
  function showError(message) {
      const emailError = document.querySelector(".email-error");
      emailError.innerText = message;

      if (message.includes("Account deactivated")) {
          document.getElementById("loginBtn").style.display = "none";
          document.getElementById("reactivateBtn").style.display = "inline-block";
      }
  }

</script>
<script src="js/script.js"></script>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jsencrypt/bin/jsencrypt.min.js"></script>

</body>
</html>
