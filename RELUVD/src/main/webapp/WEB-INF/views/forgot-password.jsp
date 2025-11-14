<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
<style>
	body, html {
	  margin: 0;
	  padding: 0;
	  min-height: 100vh;
	  display: flex;
	  flex-direction: column;
	}
	.container {
	  flex: 1; /* Push footer down */
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  padding: 2rem 1rem;
	  box-sizing: border-box;
	}
	#forgotPasswordForm .btn {
	  margin-top: 0rem;
	}
	.timer-container {
	  margin-bottom: 1rem; 
	}
	.input-field input {
	  border: none;
	  background: none;
	  outline: none;
	  width: 80%;
	  font-size: 1rem;
	  color: #333;
	  height:20px;
	  padding: 0.5rem 2rem 0.5rem 2rem;
	  box-sizing: border-box;
	}

	.input-field i.fas:first-child {
	  position: absolute;
	  left: 1rem;
	  top: 50%;
	  transform: translateY(-50%);
	  font-size: 1rem;
	  color: #244C45;
	}

	</style>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=6">
</head>
<body>
<header class="custom-header">
    <div style="display: flex; align-items: center;">
        <img src="${pageContext.request.contextPath}/images/reluvd-logo.png" alt="ReLuvd Logo" class="logo"/>
        <div class="brand-text">
            <h1>ReLuvd</h1>
            <p>Because OLD is the new NEW!</p>
        </div>
    </div>
</header>

<div class="container">
    <div class="form-box">
        <div class="form-side">
            <form class="form" id="forgotPasswordForm" method="post" action="/reset-password">
                <h2>Forgot Password</h2>

                <!-- Email -->
                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="Enter your registered email" required/>
					<span class="error-message email-error"></span>
                </div>
               

                <!-- Send OTP -->
                <button type="button" class="btn" onclick="sendForgotPasswordOtp()">Send OTP</button>
                <span class="error-message otp-error-global"></span>

                <!-- OTP Section -->
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
                        <button type="button" id="resendBtn" onclick="sendForgotPasswordOtp()" disabled>Resend OTP</button>
                    </div>
                    <button type="button" id="verifyOtpBtn" class="btn" onclick="verifyOtp()">Verify OTP</button>
                </div>

				<!-- New Password -->
				<div class="input-field" id="newPassSection" style="display: none;">
				    <i class="fas fa-lock"></i>
				    <input type="password" name="newPassword" placeholder="Password" required />
				    <i class="fas fa-eye toggle-password" onclick="togglePassword(this)"></i>
				</div>
				<span class="error-message new-pass-error"></span>

				<!-- Confirm Password -->
				<div class="input-field" id="confirmPassSection" style="display: none;">
				    <i class="fas fa-lock"></i>
				    <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
				    <i class="fas fa-eye toggle-password" onclick="togglePassword(this)"></i>
				</div>
				<span class="error-message confirm-pass-error"></span>



                <!-- Submit -->
                <button class="btn" id="resetBtn" type="button" onclick="submitNewPassword()" style="display: none;">Reset Password</button>
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

<!-- Scripts -->
<script>
    const BASE_URL = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/forgot.js"></script>
</body>
</html>
