<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Log In | RentaHub</title>
                <link rel="icon" type="image/x-icon" href="images/logo-only.png" />
                <!-- Latest compiled and minified CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
                <!-- Latest compiled JavaScript -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
                        integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
                        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
                    <script src="script.js"></script>
                    <!-- FONTS -->
                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
                        <link href="https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap" rel="stylesheet" />
                            <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js">
                            </script>
                            <link rel="stylesheet" type="text/css" href="styles.css" />
                        </head>
                        <script>
                            (function () {
                            emailjs.init("0PPn2GEXyW3Nrjq_v"); // Replace with your EmailJS User ID
                            })();
                            
                            
                            function togglePasswordVisibility(id) {
                            const passwordField = document.getElementById(id);
                            const eyeIcon = document.getElementById('eyeIcon');
                            
                            const isPassword = passwordField.type === 'password';
                            passwordField.type = isPassword ? 'text' : 'password';
                            eyeIcon.className = isPassword ? 'bi bi-eye' : 'bi bi-eye-slash';
                            }
                            
                            function generateOtp(length = 6) {
                            let otp = "";
                            const digits = "0123456789";
                            for (let i = 0; i &lt; length; i++) {
                                                        otp += digits.charAt(Math.floor(Math.random() * digits.length));
                                                        }
                                                        return otp;
                                                        }
                                                            
                                                            
                                                            
                                            function sendOtpEmail(toEmail, otpCode) {
                                                        console.log("OTP:", otpCode); // Debug
                                                        const templateParams = {
                                                        to_email: toEmail,
                                                        otp_code: otpCode
                                                        };
                                                            
                                                    emailjs.send('service_8p2cgis', 'template_rkr2qz9', templateParams)
                                                        .then(function (response) {
                                                        console.log('SUCCESS!', response.status, response.text);
                                                        }, function (error) {
                                                        console.error('FAILED...', error);
                                                        });
                                                        }
                                                            
                                                    function startResendCooldown(duration = 30) {
                                                        const $btn = $('#btn-resend-otp');
                                                        let timeLeft = duration;
                                                            
                                                    $btn.prop('disabled', true).css('pointer-events', 'none');
                                                        $btn.text(`Resend in ${timeLeft}s`);
                                                            
                                                    const countdown = setInterval(() =&gt; {
                                                        timeLeft--;
                                                        $btn.text(`Resend in ${timeLeft}s`);
                                                            
                                                    if (timeLeft &lt;= 0) {
                                                clearInterval(countdown);
                                                $btn.prop('disabled', false).css('pointer-events', 'auto');
                                                $btn.text('Resend Again');
                                                }
                                                }, 1000);
                                                }
                                                    
                                                    
                                                    
                                    $(document).ready(() =&gt; {
                                                const currentUser = JSON.parse(localStorage.getItem("currentUser"));
                                                if (currentUser &amp;&amp; currentUser.email &amp;&amp; currentUser.role) {
                                                // Redirect immediately if already logged in
                                                redirectToDashboard(currentUser.role);
                                                return; // Prevent any further code running
                                                }
                                                    
                                            $(document).on('click', '#button-login', function () {
                                                const email = $("#email").val().trim();
                                                const password = $("#password").val().trim();
                                                const termsAccepted = $("#login-checkbox-terms").is(":checked");
                                                    
                                            hideError("#login-error-box", "#login-error-msg");
                                                    
                                            if (!email || !password) {
                                                return showError("Email and password are required.", "#login-error-box", "#login-error-msg");
                                                }
                                                    
                                            if (email.length &gt; 1000) {
                                                return showError("Email too long.", "#login-error-box", "#login-error-msg");
                                                }
                                                    
                                            if (password.length &gt; 1000) {
                                                return showError("Password too long.", "#login-error-box", "#login-error-msg");
                                                }
                                                    
                                            if (hasWhitespace(email)) {
                                                return showError("Email must not contain spaces.", "#login-error-box", "#login-error-msg");
                                                }
                                                    
                                            if (hasWhitespace(password)) {
                                                return showError("Email must not contain spaces.", "#login-error-box", "#login-error-msg");
                                                }
                                                    
                                            if (!isValidEmailChars(email)) return showError("Email contains invalid characters.", "#login-error-box", "#login-error-msg");
                                                    
                                                    
                                        if (!isValidEmailFormat(email)) {
                                                showError("Please enter a valid email address.", "#login-error-box", "#login-error-msg");
                                                return;
                                                }
                                                    
                                            if (!isValidPasswordChars(password)) {
                                                showError("Password contains invalid characters.", "#login-error-box", "#login-error-msg");
                                                return;
                                                }
                                                    
                                            const passwordCheck = isStrongPassword(password);
                                                if (!passwordCheck.isValid) return showError(passwordCheck.errors.join("<br/>"), "#login-error-box", "#login-error-msg");
                                    
                                    if (!termsAccepted) {
                                    return showError("You must accept the Terms and Conditions to continue.", "#login-error-box", "#login-error-msg");
                                    }
                                    
                                    // AJAX call to load apartment.xml and validate credentials
$.ajax({
  url: "apartment.xml",
  dataType: "xml",
  success: function(xml) {
    let userFound = false;
    
    $(xml).find("user").each(function() {
      const storedEmail = $(this).find("email").text().trim();
        const uncrypted = $(this).find("password").text().trim();
      const storedPassword = xorDecipher(uncrypted, 'rentahub');
      const role = $(this).find("userRole").text().trim();
      const status = $(this).find("status").text().trim();
      const id = $(this).attr('id'); 

      if (email === storedEmail &amp;&amp; password === storedPassword) {
        userFound = true;

        // Check if user is archived
        if (status === "Archived") {
          showError("This account is archived. Contact support.", "#login-error-box", "#login-error-msg");
          return false; // Exit loop but mark userFound=true
        }

        // Proceed with login if not archived
        const user = { id, email, role, status };
        localStorage.setItem("currentUser", JSON.stringify(user));
        redirectToDashboard(role);
        return false; // Stop iterating
      }
    });

    if (!userFound) {
        
      showError("Email or password not found.", "#login-error-box", "#login-error-msg");
    }
  },
  error: function() {
    showError("Failed to load user data.", "#login-error-box", "#login-error-msg");
  }
});


                                    });
                                    
                                    
                                    $(document).on('click', '#btn-forgot-pass', function () {
                                    $('#login-div').addClass("d-none");
                                    $('#enter-email-div').removeClass("d-none").addClass("d-block");
                                    $("#email").val('');
                                    $("#password").val('');
                                    });
                                    
                                    let otp = "";
                                    let otpEmail = "";
                                    
                                    $(document).on('click', '#button-otp-email', function () {
                                    otpEmail = $("#otp-email").val().trim();
                                    hideError("#error-box-otp-email", "#error-text-otp-email");
                                    
                                    if (!otpEmail) {
                                    return showError("Email is required.", "#error-box-otp-email", "#error-text-otp-email");
                                    }
                                    
                                    if (otpEmail.length &gt; 1000) {
                                    return showError("Email too long.", "#error-box-otp-email", "#error-text-otp-email");
                                    }
                                    
                                    if (hasWhitespace(otpEmail)) {
                                    return showError("Email must not contain spaces.", "#error-box-otp-email", "#error-text-otp-email");
                                    }
                                    
                                    if (!isValidEmailChars(otpEmail)) return showError("Email contains invalid characters.", "#error-box-otp-email", "#error-text-otp-email");
                                    
                                    
                                    if (!isValidEmailFormat(otpEmail)) {
                                    showError("Please enter a valid email address.", "#error-box-otp-email", "#error-text-otp-email");
                                    return;
                                    }
                                    
                                    // AJAX call to load users.xml and validate credentials
                                    $.ajax({
                                    url: "apartment.xml",
                                    dataType: "xml",
                                    success: function (xml) {
                                    let userFound = false;
                                    
                                    $(xml).find("user").each(function () {
                                    const storedEmail = $(this).find("email").text().trim();
                                    
                                    if (otpEmail === storedEmail) {
                                    userFound = true;
                                    otp = generateOtp();
                                    sendOtpEmail(otpEmail, otp);
                                    
                                    
                                    $('#enter-email-div').addClass("d-none");
                                    $('#otp-div').removeClass("d-none").addClass("d-block");
                                    $("#otp-email").val('');
                                    
                                    return false; // Stop iterating once user is found
                                    }
                                    });
                                    
                                    if (!userFound) {
                                    showError("Email not found in Database.", "#error-box-otp-email", "#error-text-otp-email");
                                    }
                                    },
                                    error: function () {
                                    showError("Failed to load user data.", "#error-box-otp-email", "#error-text-otp-email");
                                    }
                                    });
                                    
                                    
                                    
                                    
                                    });
                                    
                                    $(document).on('click', '#btn-resend-otp', function () {
                                    otp = generateOtp();
                                    sendOtpEmail(otpEmail, otp);
                                    startResendCooldown(60);
                                    });
                                    
                                    
                                    $(document).on('click', '#button-otp', function () {
                                    const otpInput = $("#otp-input").val().trim();
                                    
                                    hideError("#error-box-otp", "#error-text-otp");
                                    
                                    if (!otpInput) {
                                    return showError("OTP is required.", "#error-box-otp", "#error-text-otp");
                                    }
                                    
                                    if (otpInput.length &gt; 1000) {
                                    return showError("OTP too long.", "#error-box-otp", "#error-text-otp");
                                    }
                                    
                                    if (hasWhitespace(otpInput)) {
                                    return showError("OTP must not contain spaces.", "#error-box-otp", "#error-text-otp");
                                    }
                                    
                                    if (!isNumber(otpInput)) {
                                    return showError("OTP must not be numbers only.", "#error-box-otp", "#error-text-otp");
                                    }
                                    
                                    if (otp !== otpInput) return showError("OTP do not match.", "#error-box-otp", "#error-text-otp");
                                    
                                    $('#otp-div').addClass("d-none");
                                    $('#change-pass-div').removeClass("d-none").addClass("d-block");
                                    $("#otp-input").val('');
                                    });
                                    
                                    $(document).on('click', '#button-reset-password', function () {
                                    event.preventDefault();
                                    const password = $("#login-new-password").val().trim();
                                    const confirmPassword = $("#login-confirm-password").val().trim();
                                    
                                    if (!password || !confirmPassword) {
                                    return showError("All required fields must be filled.", "#error-box-change-pass", "#error-text-change-pass");
                                    }
                                    // Check for whitespace-only inputs
                                    if ([password, confirmPassword].some(isWhitespaceOnly)) {
                                    return showError("Whitespace-only fields are not allowed.", "#error-box-change-pass", "#error-text-change-pass");
                                    }
                                    
                                    // Check for have whitespace inputs
                                    if ([password, confirmPassword].some(hasWhitespace)) {
                                    return showError("Fields must not have any whitespaces.", "#error-box-change-pass", "#error-text-change-pass");
                                    }
                                    
                                    // Length validation
                                    if ([password, confirmPassword].some(f =&gt; exceedsLengthLimit(f))) {
                                    return showError("One or more fields exceed the length limit.", "#error-box-change-pass", "#error-text-change-pass");
                                    }
                                    
                                    // Password validation
                                    if (password !== confirmPassword) return showError("Password do not match.", "#error-box-change-pass", "#error-text-change-pass");
                                    if (!isValidPasswordChars(password)) return showError("Password contains invalid characters.", "#error-box-change-pass", "#error-text-change-pass");
                                    const passwordCheck = isStrongPassword(password);
                                    if (!passwordCheck.isValid) {
                                    return showError(passwordCheck.errors.join("<br/>"), "#error-box-change-pass", "#error-text-change-pass");
                                    }
                                    
                                    $('#change-pass-div').addClass("d-none");
                                    $('#success-change-pass-div').removeClass("d-none").addClass("d-block");
                                    $("#login-new-password").val('');
                                    $("#login-confirm-password").val('');
                                    
                                    // Set the password into the hidden field so it can be submitted
                                    $("#hidden-login-change-pass").val(xorCipher(password, 'rentahub'));
                                    $("#hidden-login-change-pass-email").val(otpEmail);
                                    
                                    // Manually submit if needed (optional)
                                    $("#modify-renter")[0].submit(); 
                                                                            });
                                                                                
                                                                        $(document).on('click', '#button-reset-password-success', function () {
                                                                            $('#success-change-pass-div').addClass("d-none");
                                                                            $('#login-div').removeClass("d-none").addClass("d-block");
                                                                            });
                                                                                
                                                                        $(document).on('click', '#button-otp-email-cancel', function () {
                                                                            $('#enter-email-div').addClass("d-none");
                                                                            $('#login-div').removeClass("d-none").addClass("d-block");
                                                                            });
                                                                                
                                                                        $(document).on('click', '#button-otp-cancel', function () {
                                                                            $('#otp-div').addClass("d-none");
                                                                            $('#enter-email-div').removeClass("d-none").addClass("d-block");
                                                                            });
                                                                                
                                                                        $(document).on('click', '#button-reset-cancel', function () {
                                                                            $('#change-pass-div').addClass("d-none");
                                                                            $('#login-div').removeClass("d-none").addClass("d-block");
                                                                            });
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                    });
                                                                                
                                                                                
                                                                                
                                                            </script>
                                    
                                    <body>
                <!-- Loading Screen -->
                <div id="loading-screen">
                    <div class="spinner"></div>
                    <p>Loading, please wait...</p>
                </div>
                                        <audio id="error-sound" src="audio/error.mp3" preload="auto"></audio>
                                        <div class="container d-flex justify-content-center align-items-center min-vh-100">
                                            <div class="row w-100 shadow rounded-4 overflow-hidden" style="max-width: 900px;">
                                                
                                                <!-- Left Panel: Logo and Tagline -->
                                                <div class="col-md-6 d-flex flex-column justify-content-center align-items-center bg-white p-5">
                                                    <div class="text-center">
                                                        <!-- Your logo -->
                                                        <img src="images/menu-logo.png" alt="RentaHub Logo" class="d-block img-fluid" />
                                                    </div>
                                                </div>
                                                
                                                <!-- Right Panel: Login Form -->
                                                <div class="d-block col-md-6 gradient-red-bg text-white p-5" id="login-div">
                                                    <div class="mb-4">
                                                        <p class="h2">Welcome Back!</p>
                                                        <p>Please log in to your account</p>
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <input type="email" class="form-control" id="email" placeholder="name@example.com"/>
                                                            <label for="email">Email address</label>
                                                        </div>
                                                        <div class="form-floating col-12 position-relative mb-3">
                                                            <input type="password" class="form-control" id="password" placeholder="Password"/>
                                                                <label for="password">Password</label>
                                                                <button class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                        onclick="togglePasswordVisibility('password')" id="password">
                                                                    <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                </button>
                                                            </div>
                                                            
                                                            <div class="col-12 d-flex mb-3">
                                                                <a class="d-flex small font-white ms-auto" id="btn-forgot-pass" style="cursor: pointer;">Forgot Password?</a>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <label class="custom-checkbox-container-white">
                                                                    <input type="checkbox" class="custom-checkbox-white font-white"
                                                                           id="login-checkbox-terms"/>
                                                                        <a class="font-white text-decoration-underline h6" data-bs-toggle="modal"
                                                                           data-bs-target="#modalViewTerms" style="cursor: pointer;">Agree to the Terms and Conditions. *</a>
                                                                    </label>
                                                                </div>
                                                                <div class="d-flex flex-column justify-content-between mt-3">
                                                                    <div id="login-error-box"
                                                                         class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-12"
                                                                         style="color:#a6192e; background-color: white;">
                                                                        <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                        <div>
                                                                            <strong class="fs-5">Warning!</strong><br />
                                                                            <span class="small" id="login-error-msg"></span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="d-flex justify-content-center align-items-end ms-auto">
                                                                        <button class="btn-white-fill d-flex ms-auto align-items-center align-self-end px-4 py-1"
                                                                                id="button-login">Log In</button>
                                                                        
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Right Panel: Enter EMAIL -->
                                                            <div class="d-none col-md-6 gradient-red-bg text-white p-5" id="enter-email-div">
                                                                <div class="mb-4">
                                                                    <p class="h2">Enter Email</p>
                                                                    <p>You will get an OTP via email</p>
                                                                </div>
                                                                <div class="form-floating mb-3 col-12">
                                                                    <input type="text" class="form-control" id="otp-email" placeholder=""/>
                                                                        <label for="otp-email">Enter Email</label>
                                                                    </div>
                                                                    <div class="d-flex flex-column justify-content-center align-items-center">
                                                                        <button type="button" class="btn-white-fill ms-auto d-flex align-items-center align-self-center px-4 py-1"
                                                                                id="button-otp-email">
                                                                            Send OTP
                                                                        </button>
                                                                        <button type="button" class="btn-white d-flex mt-3 ms-auto align-items-center align-self-center px-4 py-1"
                                                                                id="button-otp-email-cancel">
                                                                            Cancel
                                                                        </button>
                                                                    </div>
                                                                    <div id="error-box-otp-email"
                                                                         class="alert d-none flex-column align-items-start gap-3 p-3 border-0 rounded-3 col-12"
                                                                         style="color:#a6192e; background-color: white;">
                                                                        <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                        <div>
                                                                            <strong class="fs-5">Warning!</strong><br />
                                                                            <span class="small" id="error-text-otp-email"></span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- Right Panel: OTP -->
                                                                <div class="d-none col-md-6 gradient-red-bg text-white p-5" id="otp-div">
                                                                    <div class="mb-4">
                                                                        <p class="h2">Verification</p>
                                                                        <p>You will get an OTP via email</p>
                                                                    </div>
                                                                    <div class="form-floating mb-3 col-12">
                                                                        <input type="text" class="form-control" id="otp-input" placeholder=""/>
                                                                            <label for="otp-input">Enter OTP</label>
                                                                        </div>
                                                                        <div class="d-flex flex-column justify-content-center align-items-center">
                                                                            <button type="button" class="btn-white-fill d-flex ms-auto align-items-center align-self-center px-4 py-1"
                                                                                    id="button-otp">
                                                                                Verify
                                                                            </button>
                                                                            <button type="button" class="btn-white d-flex mt-3 ms-auto align-items-center align-self-center px-4 py-1"
                                                                                    id="button-otp-cancel">
                                                                                Cancel
                                                                            </button>
                                                                        </div>
                                                                        
                                                                        <div class="col-12 d-flex flex-column small justify-content-center align-items-center mt-5 ">
                                                                            Didn't receive the verification OTP?
                                                                            <a class="d-flex small font-white" id="btn-resend-otp" style="cursor: pointer;">Resend Again</a>
                                                                        </div>
                                                                        <div id="error-box-otp"
                                                                             class="alert d-none flex-column align-items-start gap-3 p-3 border-0 rounded-3 col-12"
                                                                             style="color:#a6192e; background-color: white;">
                                                                            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                            <div>
                                                                                <strong class="fs-5">Warning!</strong><br />
                                                                                <span class="small" id="error-text-otp"></span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <!-- Right Panel: Change Password -->
                                                                    <div class="d-none col-md-6 gradient-red-bg text-white p-5" id="change-pass-div">
                                                                        <div class="mb-4">
                                                                            <p class="h2">Create New Password</p>
                                                                            <p>Your new password must be different from previous used password.</p>
                                                                        </div>
                                                                        <form id="modify-renter" method="POST" action="functions/change-password.php">
                                                                            
                                                                            <div class="form-floating position-relative">
                                                                                <input type="password" class="form-control" id="login-new-password" placeholder="Password" required="required"/>
                                                                                    <label for="login-new-password">Password *</label>
                                                                                    <button type="button"
                                                                                            class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                                            onclick="togglePasswordVisibility('login-new-password')">
                                                                                        <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                                    </button>
                                                                                </div>
                                                                                <div class="form-floating position-relative">
                                                                                    <input type="password" class="form-control" id="login-confirm-password" placeholder="Password" required="required"/>
                                                                                        <label for="login-confirm-password">Confirm Password *</label>
                                                                                        <button type="button"
                                                                                                class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                                                onclick="togglePasswordVisibility('login-confirm-password')">
                                                                                            <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                                        </button>
                                                                                    </div>
                                                                                    <div id="error-box-change-pass"
                                                                                         class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-12"
                                                                                         style="color:#a6192e; background-color: white;">
                                                                                        <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                                        <div>
                                                                                            <strong class="fs-5">Warning!</strong><br />
                                                                                            <span class="small" id="error-text-change-pass"></span>
                                                                                        </div>
                                                                                    </div>
                                                                                    
                                                                                    <div class="d-flex flex-column justify-content-center align-items-center">
                                                                                        <button type="submit" class="btn-white-fill d-flex ms-auto align-items-center align-self-center px-4 py-1"
                                                                                                id="button-reset-password">
                                                                                            Reset Password
                                                                                        </button>
                                                                                        <button type="button" class="btn-white d-flex mt-3 ms-auto align-items-center align-self-center px-4 py-1"
                                                                                                id="button-reset-cancel">
                                                                                            Cancel
                                                                                        </button>
                                                                                    </div>
                                                                                    <!-- TODO: REMOVE VALUE ONLY SIMulate -->
                                                                                    <input type="hidden" id="hidden-login-change-pass-email" name="email" value="rontaniegra707@gmail.com"/> 
                                                                                    <input type="hidden" id="hidden-login-change-pass" name="new_password"/>
                                                                                </form>
                                                                            </div>
                                                                            
                                                                            <!-- Right Panel: Change Password Success -->
                                                                            <div class="d-none col-md-6 gradient-red-bg text-white p-5" id="success-change-pass-div">
                                                                                <div class="mb-4 d-flex flex-column align-items-center justify-content-center">
                                                                                    <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#FFFFFF">
                                                                                        <path
                                                                                            d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z" />
                                                                                    </svg>
                                                                                    <p class="h2 font-white text-center mt-2">Password Changed!</p>
                                                                                    <button type="button" class="btn-white-fill d-flex align-items-center align-self-center px-4 py-1"
                                                                                            id="button-reset-password-success">
                                                                                        Confirm
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            
                                                                            
                                                                        </div>
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    </div>
                    
                                                                
                                                                <!-- Modal View Terms and Conditions -->
                                                                <div class="modal fade" id="modalViewTerms" tabindex="-1">
                                                                    <div class="modal-dialog modal-dialog-centered modal-md">
                                                                        <div class="modal-content p-4">
                                                                            
                                                                            <!-- Modal Header -->
                                                                            <div class="modal-header d-flex align-items-center justify-content-center">
                                                                                <p class="modal-title h2 font-red text-center">Terms &amp; Conditions</p>
                                                                            </div>
                                                                            
                                                                            <!-- Modal body -->
                                                                            <div class="modal-body d-flex align-items-center justify-content-center">
                                                                                <div class="terms-content" style="max-height: 300px; overflow-y: auto; text-align: left; font-size: 0.9rem;">
                                                                                    <p><strong>Welcome to our system.</strong> Please read the terms below before using the platform. By using the system, you agree to these conditions.</p>
                                                                                    
                                                                                    <hr/>
                                                                                        
                                                                                        <h5>1. Purpose of Data Collection</h5>
                                                                                        <p>We collect data to support system functions and protect your account. Information you provide helps us verify your identity. We use your data to enable login, send important messages, and process system-related actions. Some data may help us analyze usage patterns to improve performance. We do not collect more than what is needed.</p>
                                                                                        <ul>
                                                                                            <li>Names and IDs help confirm who you are.</li>
                                                                                            <li>Email addresses are used for updates and password recovery.</li>
                                                                                        </ul>
                                                                                        
                                                                                        <hr/>
                                                                                            
                                                                                            <h5>2. Data Retention Policy</h5>
                                                                                            <p>We store your personal data while your account is active. Once you stop using the system, we follow a specific schedule:</p>
                                                                                            <ul>
                                                                                                <li>Active accounts: data is retained while your account is in use.</li>
                                                                                                <li>Inactive accounts: data is kept for up to 5 years, unless laws require a longer period.</li>
                                                                                                <li>Request for deletion: you may ask to delete your data. We follow through unless required to keep records.</li>
                                                                                            </ul>
                                                                                            <p>All records are stored securely. Data is removed from the system once retention ends. Backup data is also deleted when no longer needed.</p>
                                                                                            
                                                                                            <hr/>
                                                                                                
                                                                                                <h5>3. User Responsibilities</h5>
                                                                                                <p>Users must follow these rules when using the system:</p>
                                                                                                <ul>
                                                                                                    <li>Keep your account information safe. Do not share your password.</li>
                                                                                                    <li>Provide true and complete information during registration.</li>
                                                                                                    <li>Notify us if your contact information changes.</li>
                                                                                                    <li>Use the platform only for legal, fair, and approved activities.</li>
                                                                                                    <li>Check your actions. Make sure they do not harm others or the system.</li>
                                                                                                </ul>
                                                                                                <p>Failure to follow the rules may result in suspension or permanent removal of your account.</p>
                                                                                                
                                                                                                <hr/>
                                                                                                    
                                                                                                    <h5>4. Prohibited Actions</h5>
                                                                                                    <p>The following are not allowed:</p>
                                                                                                    <ul>
                                                                                                        <li>Using someone else’s account.</li>
                                                                                                        <li>Creating fake identities or submitting false documents.</li>
                                                                                                        <li>Uploading viruses or harmful software.</li>
                                                                                                        <li>Posting offensive, threatening, or illegal content.</li>
                                                                                                        <li>Collecting other users’ information without permission.</li>
                                                                                                        <li>Accessing restricted areas or bypassing system rules.</li>
                                                                                                        <li>Disrupting normal functions of the system.</li>
                                                                                                    </ul>
                                                                                                    <p>Violations may lead to penalties, account removal, or legal action.</p>
                                                                                                    
                                                                                                    <hr/>
                                                                                                        
                                                                                                        <h5>5. Legal Compliance</h5>
                                                                                                        <p>We comply with Philippine laws on data privacy and cybersecurity.</p>
                                                                                                        <ul>
                                                                                                            <li><strong>RA 10173 - Data Privacy Act of 2012:</strong> Safeguards personal data, allows you to access or correct your data, and protects your rights.</li>
                                                                                                            <li><strong>RA 10175 - Cybercrime Prevention Act of 2012:</strong> Covers online crimes like hacking, identity theft, and cyberbullying. It ensures accountability for illegal digital actions.</li>
                                                                                                        </ul>
                                                                                                        <p>We work with authorities when required and are committed to protecting your information.</p>
                                                                                                        
                                                                                                        <hr/>
                                                                                                            
                                                                                                            <p><strong>Final Note:</strong> Use the system responsibly. If you do not agree with these terms, do not proceed. For questions or concerns, contact the system administrator.</p>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    
                                                                                                    
                                                                                                    <!-- Modal footer -->
                                                                                                    <div class="modal-footer d-flex align-items-center justify-content-center">
                                                                                                        <button type="button" class="btn-red-fill" data-bs-dismiss="modal">Close</button>
                                                                                                    </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                                        
                                                                                    </body>
                                                                                    
                                                                                </html>
    </xsl:template>
</xsl:stylesheet>