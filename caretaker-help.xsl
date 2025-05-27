<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>FAQs/Help Support &#128490; | RentaHub</title>
                <link rel="icon" type="image/x-icon" href="images/logo-only.png" />
                <!-- Latest compiled and minified CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
                    <!-- Latest compiled JavaScript -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
                            integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
                            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
                    
                    <!-- FONTS -->
                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
                        <link href="https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap" rel="stylesheet" />
                            <link rel="stylesheet" type="text/css" href="styles.css" />
                            <!-- jQuery Script -->
                            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                            <script src="script.js"></script>
                        </head>
                        <script>
                // Allowed roles for this page
                const allowedRoles = ['admin', 'caretaker'];
                
                // Function to sign out user (clear storage and redirect to login)
                function signOut() {
                localStorage.removeItem('currentUser');
                window.location.href = 'login.xml'; // Adjust to your login page URL
                }
                
                // Verify user role function (custom logic)
                function verifyUserRole(userRole) {
                // Add any role-specific logic here
                console.log(`User role verified: ${userRole}`);
                }
                
                // Main check on page load
                function checkUserAccess() {
                const currentUserStr = localStorage.getItem('currentUser');
                if (!currentUserStr) {
                signOut();
                return;
                }
                
                let currentUser;
                try {
                currentUser = JSON.parse(currentUserStr);
                } catch (e) {
                console.error('Failed to parse currentUser from localStorage', e);
                signOut();
                return;
                }
                
                const { email, role } = currentUser;
                
                if (!email || !role) {
                signOut();
                return;
                }
                
                if (!allowedRoles.includes(role)) {
                signOut();
                return;
                }
                
                verifyUserRole(role);
                
                // User info available for use
                console.log('Logged in user:', email, 'Role:', role);
                
                // You can assign to variables or update UI as needed
                window.loggedInUsername = email;
                window.loggedInUserRole = role;
                }
                
                // Call check on page load
                            document.addEventListener('DOMContentLoaded', checkUserAccess);
                
                            function togglePasswordVisibility(id) {
                            const passwordField = document.getElementById(id);
                            const eyeIcon = document.getElementById('eyeIcon');
                            
                            const isPassword = passwordField.type === 'password';
                            passwordField.type = isPassword ? 'text' : 'password';
                            eyeIcon.className = isPassword ? 'bi bi-eye' : 'bi bi-eye-slash';
                            }
                            
                            $(document).ready(function () {
                            $(".accordion").addClass("col-12");
                            });
                
                $(document).ready(function() {
                const currentUserStr = localStorage.getItem('currentUser');
                if (!currentUserStr) return;
                
                const currentUser = JSON.parse(currentUserStr);
                if (currentUser.role === 'admin') {
                $('#accounts-menu-item').show();
                } else {
                $('#accounts-menu-item').hide();
                }
                });
                        </script>
                        
                        <body class="h-100">
                <!-- Loading Screen -->
                <div id="loading-screen">
                    <div class="spinner"></div>
                    <p>Loading, please wait...</p>
                </div>
                            <audio id="error-sound" src="audio/error.mp3" preload="auto"></audio>
                            
                            <!-- Toggle Button for sm and md screens -->
                            <button class="btn d-block d-xl-none m-3" type="button" data-bs-toggle="offcanvas" data-bs-target="#sideMenuOffcanvas"
                                    aria-controls="sideMenuOffcanvas">
                                <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8E1616">
                                    <path d="M120-240v-80h720v80H120Zm0-200v-80h720v80H120Zm0-200v-80h720v80H120Z" />
                                </svg>
                            </button>
                            <div class="container-fluid h-100">
                                <div class="row h-100">
                                    <!--SIDE MENU LG-->
                                    <div
                                        class="offcanvas-xl offcanvas-start d-xl-flex flex-column p-0 bg-light shadow-lg side-menu position-fixed top-0 h-100 align-items-start border-end rounded-end-4"
                                        tabindex="-1" id="sideMenuOffcanvas" aria-labelledby="sideMenuOffcanvasLabel">
                                        <div style="
                                                background-color: white;
                                                position: relative;
                                                min-width: 37vh;
                                                max-width: 37vh;
                                                width: 37vh;
                                                border-top-right-radius: 1rem;
                                                " class="border-end col-sm-2 p-0 m-0">
                                            <img src="images/menu-logo.png" alt="RentaHub Logo" class="d-block img-fluid" />
                                        </div>
                                        <ul class="nav nav-pills nav-justified flex-column w-100 pt-4">
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-dashboard.xml">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z" />
                                                    </svg>
                                                    Dashboard
                                                </a>
                                            </li>
                                <li class="nav-item" id="accounts-menu-item" style="display: none;">
                                    <a class="nav-link sidebar-nav mt-1 " href="admin-accounts.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3">
                                            <path d="M400-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47ZM80-160v-112q0-33 17-62t47-44q51-26 115-44t141-18h14q6 0 12 2-8 18-13.5 37.5T404-360h-4q-71 0-127.5 18T180-306q-9 5-14.5 14t-5.5 20v32h252q6 21 16 41.5t22 38.5H80Zm560 40-12-60q-12-5-22.5-10.5T584-204l-58 18-40-68 46-40q-2-14-2-26t2-26l-46-40 40-68 58 18q11-8 21.5-13.5T628-460l12-60h80l12 60q12 5 22.5 11t21.5 15l58-20 40 70-46 40q2 12 2 25t-2 25l46 40-40 68-58-18q-11 8-21.5 13.5T732-180l-12 60h-80Zm40-120q33 0 56.5-23.5T760-320q0-33-23.5-56.5T680-400q-33 0-56.5 23.5T600-320q0 33 23.5 56.5T680-240ZM400-560q33 0 56.5-23.5T480-640q0-33-23.5-56.5T400-720q-33 0-56.5 23.5T320-640q0 33 23.5 56.5T400-560Zm0-80Zm12 400Z"/>
                                        </svg>
                                        Accounts
                                    </a>
                                    </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1 " href="caretaker-tasks.xml">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h168q13-36 43.5-58t68.5-22q38 0 68.5 22t43.5 58h168q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm80-80h280v-80H280v80Zm0-160h400v-80H280v80Zm0-160h400v-80H280v80Zm200-190q13 0 21.5-8.5T510-820q0-13-8.5-21.5T480-850q-13 0-21.5 8.5T450-820q0 13 8.5 21.5T480-790ZM200-200v-560 560Z" />
                                                    </svg>
                                                    Tasks
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-renter.xml" id="journal-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M40-160v-112q0-34 17.5-62.5T104-378q62-31 126-46.5T360-440q66 0 130 15.5T616-378q29 15 46.5 43.5T680-272v112H40Zm720 0v-120q0-44-24.5-84.5T666-434q51 6 96 20.5t84 35.5q36 20 55 44.5t19 53.5v120H760ZM360-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47Zm400-160q0 66-47 113t-113 47q-11 0-28-2.5t-28-5.5q27-32 41.5-71t14.5-81q0-42-14.5-81T544-792q14-5 28-6.5t28-1.5q66 0 113 47t47 113ZM120-240h480v-32q0-11-5.5-20T580-306q-54-27-109-40.5T360-360q-56 0-111 13.5T140-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T440-640q0-33-23.5-56.5T360-720q-33 0-56.5 23.5T280-640q0 33 23.5 56.5T360-560Zm0 320Zm0-400Z" />
                                                    </svg>
                                                    Renter Information
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-room.xml" id="ledger-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M120-120v-80h80v-640h400v40h160v600h80v80H680v-600h-80v600H120Zm160-640v560-560Zm160 320q17 0 28.5-11.5T480-480q0-17-11.5-28.5T440-520q-17 0-28.5 11.5T400-480q0 17 11.5 28.5T440-440ZM280-200h240v-560H280v560Z" />
                                                    </svg>
                                                    Room Information
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-billings.xml" id="savings-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
                                                    </svg>
                                                    Billings
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-payments.xml" id="budgeting-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                                    </svg>
                                                    Payments
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1 active" href="caretaker-help.xml" id="help-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M478-240q21 0 35.5-14.5T528-290q0-21-14.5-35.5T478-340q-21 0-35.5 14.5T428-290q0 21 14.5 35.5T478-240Zm-36-154h74q0-33 7.5-52t42.5-52q26-26 41-49.5t15-56.5q0-56-41-86t-97-30q-57 0-92.5 30T342-618l66 26q5-18 22.5-39t53.5-21q32 0 48 17.5t16 38.5q0 20-12 37.5T506-526q-44 39-54 59t-10 73Zm38 314q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z" />
                                                    </svg>
                                                    Help
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="logout.xml" id="logout-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h280v80H200Zm440-160-55-58 102-102H360v-80h327L585-622l55-58 200 200-200 200Z" />
                                                    </svg>
                                                    Log Out
                                                </a>
                                            </li>
                                        </ul>
                                        <div class="d-flex mt-auto align-items-center align-self-center flex-column">
                                            <p class="small align-self-center fw-bold mb-0 pb-0 current-date"></p>
                                            <p class="align-self-center pt-0 mt-0" style="font-size: 0.6rem">
                                                &#169; <span class="current-year"></span> RentaHub. All Rights
                                                Reserved.
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- MAIN CONTENT -->
                                    <div class="main-container h-100 p-4" id="main-container">
                                        <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
                                            
                                            <div class="d-flex flex-row align-items-center">
                                                <p class="h2 font-red-gradient">FAQs / Help</p>
                                                <div class=" ms-2 d-flex flex-row align-items-center">
                                                    <select id="languageSelect" class="form-select custom-select">
                                                        <option value="en" selected="selected">English</option>
                                                        <option value="tl">Filipino</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-row align-items-center">
                                                <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1" data-bs-toggle="modal"
                                                        data-bs-target="#modalSendInquiry">
                                                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#8E1616">
                                                        <path
                                                            d="M160-160q-33 0-56.5-23.5T80-240v-480q0-33 23.5-56.5T160-800h640q33 0 56.5 23.5T880-720v480q0 33-23.5 56.5T800-160H160Zm320-280L160-640v400h640v-400L480-440Zm0-80 320-200H160l320 200ZM160-640v-80 480-400Z" />
                                                    </svg>
                                                    Send Inquiry
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="horizontal mt-1 mb-2"></div>
                                        <!-- Nav Pills -->
                                        <div class="nav-pills-red border-bottom border-3 border-danger">
                                            <ul class="nav nav-pills mt-3">
                                                <li class="nav-item">
                                                    <a class="nav-link active" data-bs-toggle="pill" href="#renter-management">Renter Management</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="pill" href="#billing-payments">Billing &amp; Payments</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="pill" href="#task-management">Task Management</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="pill" href="#room-unit-management">Room/Unit Management</a>
                                                </li>
                                            </ul>
                                        </div>
                                        
                                        <!-- Tab panes -->
                                        <div class="tab-content">
                                            
                                            <!-- Renter Management Tab -->
                                            <div class="tab-pane container active" id="renter-management">
                                                <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                    <div class="accordion mt-4" id="accordionRenter">
                                                        
                                                        <!-- Add Renter -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingA1">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqA1">
                                                                    <span class="text-start text-wrap w-100">How do I add a new renter?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqA1" class="accordion-collapse collapse" data-bs-parent="#accordionRenter">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-person-lines-fill"></i> Renter
                                                                        Information</span> tab, click
                                                                    <button type="button" class="ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1"
                                                                            id="renter-button-modify-renter" data-bs-toggle="modal" data-bs-target="#modalAddRenter">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="18px" viewBox="0 -960 960 960" width="18px"
                                                                             fill="#8E1616">
                                                                            <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
                                                                        </svg>
                                                                        <span class="fw-semibold" style="font-size: 0.875rem;">Add Renter</span>
                                                                    </button> and fill in their personal and room details, then save.
                                                                    
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Edit Renter -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingA2">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqA2">
                                                                    <span class="text-start text-wrap w-100">Can I edit renter information?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqA2" class="accordion-collapse collapse" data-bs-parent="#accordionRenter">
                                                                <div class="accordion-body">
                                                                    Yes. Navigate to <span class="badge bg-danger"><i class="bi bi-person-lines-fill"></i> Renter
                                                                        Information</span>, then click
                                                                    <button type="button" class="btn-red d-inline-flex align-baseline px-2 py-1"
                                                                            id="dashboard-button-edit-renter"
                                                                            style="font-size: 0.875rem; border-radius: 0.5rem; vertical-align: baseline;">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8E1616" class="me-1">
                                                                            <path
                                                                                d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Z" />
                                                                        </svg> Edit </button> next to the renter’s name and update the details.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Delete Renter -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingA3">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqA3">
                                                                    <span class="text-start text-wrap w-100">How do I remove a renter who has moved out?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqA3" class="accordion-collapse collapse" data-bs-parent="#accordionRenter">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-person-lines-fill"></i> Renter
                                                                        Information</span> tab, click
                                                                    <button type="button" class="btn-red d-inline-flex align-baseline px-2 py-1"
                                                                            id="dashboard-button-delete-renter"
                                                                            style="font-size: 0.875rem; border-radius: 0.5rem; vertical-align: baseline;">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8E1616" class="me-1">
                                                                            <path
                                                                                d="M261-120q-28 0-47.5-19.5T194-187v-46h572v46q0 28-19.5 47.5T699-120H261Zm-67-106v-60l43-414q2-17 14.5-28.5T280-740h122v-20q0-13 9-22.5t22-9.5h94q13 0 22.5 9.5T559-760v20h121q17 0 29.5 11.5T724-688l43 414v60H194Zm152-80h60V-620h-60v314Zm135 0h60V-620h-60v314Zm135 0h60V-620h-60v314Z" />
                                                                        </svg> Delete </button> next to the renter, and confirm the removal.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Search Renter -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingA4">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqA4">
                                                                    <span class="text-start text-wrap w-100">How do I search for a specific renter?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqA4" class="accordion-collapse collapse" data-bs-parent="#accordionRenter">
                                                                <div class="accordion-body">
                                                                    Use the search bar in the <span class="badge bg-danger"><i class="bi bi-person-lines-fill"></i>
                                                                        Renter Information</span> tab to filter by name, room number, or contact info.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Renter History -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingA5">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqA5">
                                                                    <span class="text-start text-wrap w-100">How can I view a renter’s stay and payment
                                                                        history?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqA5" class="accordion-collapse collapse" data-bs-parent="#accordionRenter">
                                                                <div class="accordion-body">
                                                                    Navigate to <span class="badge bg-danger"><i class="bi bi-person-lines-fill"></i> Renter
                                                                        Information</span>, then search the renter’s name. Their profile will display room assignments,
                                                                    move-in/move-out dates, and past billing transactions.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Billing and Payments Tab -->
                                            <div class="tab-pane container fade" id="billing-payments">
                                                <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                    <div class="accordion mt-4" id="accordionBilling">
                                                        
                                                        <!-- Generate Report -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingB1">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqB1">
                                                                    <span class="text-start text-wrap w-100">Can I generate a report?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqB1" class="accordion-collapse collapse" data-bs-parent="#accordionBilling">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-receipt"></i> Billing</span> tab, click
                                                                    <button type="button" class="ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8B0000">
                                                                            <path
                                                                                d="M280-280h80v-200h-80v200Zm320 0h80v-400h-80v400Zm-160 0h80v-120h-80v120Zm0-200h80v-80h-80v80ZM200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h560q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm0-560v560-560Z" />
                                                                        </svg>
                                                                        Generate Report
                                                                    </button> and you can check and generate some reports.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Payment History -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingB2">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqB2">
                                                                    <span class="text-start text-wrap w-100">Can I view the renter's payment history?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqB2" class="accordion-collapse collapse" data-bs-parent="#accordionBilling">
                                                                <div class="accordion-body">
                                                                    Yes, go to <span class="badge bg-danger"><i class="bi bi-cash-coin"></i> Payments</span> tab to
                                                                    view all transactions.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Mark Payment Received -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingB3">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqB3">
                                                                    <span class="text-start text-wrap w-100">How do I mark a payment as received?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqB3" class="accordion-collapse collapse" data-bs-parent="#accordionBilling">
                                                                <div class="accordion-body">
                                                                    Navigate to the <span class="badge bg-danger"><i class="bi bi-cash"></i> Payments</span> tab,
                                                                    click <span class="badge rounded-pill bg-success ms-1">Paid</span> to mark as full payment.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Check Electric Bill -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingB4">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqB4">
                                                                    <span class="text-start text-wrap w-100">How do I check the current electric bill for a
                                                                        renter?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqB4" class="accordion-collapse collapse" data-bs-parent="#accordionBilling">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-receipt"></i> Billing</span> tab, click
                                                                    <button type="button" class=" ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1"
                                                                            id="renter-button-archives" data-bs-toggle="modal" data-bs-target="#modalArchiveRenter">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8B0000">
                                                                            <path
                                                                                d="m422-232 207-248H469l29-227-185 267h139l-30 208ZM320-80l40-280H160l360-520h80l-40 320h240L400-80h-80Zm151-390Z" />
                                                                        </svg>
                                                                        Electric Bill
                                                                    </button> and check the renter payment details.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Check Water Bill -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingB5">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqB5">
                                                                    <span class="text-start text-wrap w-100">How do I check the current water bill for a
                                                                        renter?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqB5" class="accordion-collapse collapse" data-bs-parent="#accordionBilling">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-receipt"></i> Billing</span> tab, click
                                                                    <button type="button" class="ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1"
                                                                            id="renter-button-modify-renter" data-bs-toggle="modal" data-bs-target="#modalAddRenter">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8B0000">
                                                                            <path
                                                                                d="M491-200q12-1 20.5-9.5T520-230q0-14-9-22.5t-23-7.5q-41 3-87-22.5T343-375q-2-11-10.5-18t-19.5-7q-14 0-23 10.5t-6 24.5q17 91 80 130t127 35ZM480-80q-137 0-228.5-94T160-408q0-100 79.5-217.5T480-880q161 137 240.5 254.5T800-408q0 140-91.5 234T480-80Zm0-80q104 0 172-70.5T720-408q0-73-60.5-165T480-774Q361-665 300.5-573T240-408q0 107 68 177.5T480-160Zm0-320Z" />
                                                                        </svg>
                                                                        Water Bill
                                                                    </button> and check the renter payment details.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Task Management Tab -->
                                            <div class="tab-pane container fade" id="task-management">
                                                <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                    <div class="accordion mt-4" id="accordionTask">
                                                        
                                                        <!-- Add Task -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingC1">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqC1">
                                                                    <span class="text-start text-wrap w-100">How do I create a new Task?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqC1" class="accordion-collapse collapse" data-bs-parent="#accordionTask">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-clipboard-check"></i> Task Management
                                                                    </span> tab, click
                                                                    <button type="button" class="ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1"
                                                                            id="task-button-add-task" data-bs-toggle="modal" data-bs-target="#modalAddTask">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8E1616">
                                                                            <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
                                                                        </svg>
                                                                        Add Task </button> at the top right, then fill out the form with the task title, type, concerned
                                                                    person and due date.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- View Task History -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingC2">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqC2">
                                                                    <span class="text-start text-wrap w-100">How do I view past tasks history?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqC2" class="accordion-collapse collapse" data-bs-parent="#accordionTask">
                                                                <div class="accordion-body">
                                                                    Navigate to the <span class="badge bg-danger"><i class="bi bi-clipboard-check"></i> Task
                                                                        Management </span> tab,
                                                                    to review some of the completed past tasks.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Mark Completed Task -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingC3">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqC3">
                                                                    <span class="text-start text-wrap w-100">How do I mark a task as completed?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqC3" class="accordion-collapse collapse" data-bs-parent="#accordionTask">
                                                                <div class="accordion-body">
                                                                    Click the <button type="button"
                                                                                      class="ms-1 btn-red-fill d-inline-flex align-items-center gap-2 px-3 py-1" id="button-check"
                                                                                      data-bs-toggle="modal" data-bs-target="#modalCompleteTask">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#e3e3e3">
                                                                            <path d="M382-240 154-468l57-57 171 171 367-367 57 57-424 424Z" />
                                                                        </svg>
                                                                    </button> in the "Actions" column of the task list.
                                                                </div>
                                                            </div>
                                                            
                                                            
                                                            <!-- Overdue -->
                                                            <div class="accordion-item">
                                                                <h2 class="accordion-header" id="headingC4">
                                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#faqC4">
                                                                        <span class="text-start text-wrap w-100">What happens if a task becomes overdue?</span>
                                                                    </button>
                                                                </h2>
                                                                <div id="faqC4" class="accordion-collapse collapse" data-bs-parent="#accordionTask">
                                                                    <div class="accordion-body">
                                                                        Tasks past their due date will be labeled with a <span class="badge rounded-pill bg-warning"
                                                                                                                               id="status">Overdue</span>
                                                                        tag and counted in the "Overdue Tasks" section.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Search Task -->
                                                            <div class="accordion-item">
                                                                <h2 class="accordion-header" id="headingC5">
                                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#faqC5">
                                                                        <span class="text-start text-wrap w-100">How can I search for a specific task?</span>
                                                                    </button>
                                                                </h2>
                                                                <div id="faqC5" class="accordion-collapse collapse" data-bs-parent="#accordionTask">
                                                                    <div class="accordion-body">
                                                                        Go to the <span class="badge bg-danger"><i class="bi bi-clipboard-check"></i> Task Management
                                                                        </span> tab, and click the
                                                                        <button type="button"
                                                                                class="ms-1 btn-red-fill d-inline-flex align-items-center gap-2 px-3 py-1">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                                 fill="#FFFFFF">
                                                                                <path
                                                                                    d="M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z" />
                                                                            </svg>
                                                                        </button> field to search by task ID, title, or person assigned.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Room-Unit Management Tab -->
                                            <div class="tab-pane container fade" id="room-unit-management">
                                                <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                    <div class="accordion mt-4" id="accordionRoom">
                                                        
                                                        <!-- Add New Room -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingD1">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqD1">
                                                                    <span class="text-start text-wrap w-100">How do I add a new Room or Unit ?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqD1" class="accordion-collapse collapse" data-bs-parent="#accordionRoom">
                                                                <div class="accordion-body">
                                                                    Go to the <span class="badge bg-danger"><i class="bi bi-door-closed"></i> Room Information </span>
                                                                    tab, and click
                                                                    <button type="button" class="ms-1 btn-red d-inline-flex align-items-center gap-2 px-3 py-1"
                                                                            id="room-button-add-room" data-bs-toggle="modal" data-bs-target="#modalAddRoom">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#8E1616">
                                                                            <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
                                                                        </svg>
                                                                        Add Room </button> at the top right, then fill out the form to add a new room.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Room Availability -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingD2">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqD2">
                                                                    <span class="text-start text-wrap w-100">How do I update room availability?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqD2" class="accordion-collapse collapse" data-bs-parent="#accordionRoom">
                                                                <div class="accordion-body">
                                                                    Navigate to the <span class="badge bg-danger"><i class="bi bi-door-closed"></i> Room Information
                                                                    </span> tab,
                                                                    then click the status to change it into occcupied or unoccupied.
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Edit Room Prices -->
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="headingD3">
                                                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                        data-bs-target="#faqD3">
                                                                    <span class="text-start text-wrap w-100">Can I edit room prices ?</span>
                                                                </button>
                                                            </h2>
                                                            <div id="faqD3" class="accordion-collapse collapse" data-bs-parent="#accordionRoom">
                                                                <div class="accordion-body">
                                                                    Yes, Go to the <span class="badge bg-danger"><i class="bi bi-door-closed"></i> Room Information
                                                                    </span> tab,
                                                                    click the <button type="button"
                                                                                      class="ms-1 btn-red-fill d-inline-flex align-items-center gap-2 px-3 py-1" id="button-edit"
                                                                                      data-bs-toggle="modal" data-bs-target="#modalModifyRoom">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                             fill="#FFFFFF">
                                                                            <path
                                                                                d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Zm640-584-56-56 56 56Zm-141 85-28-29 57 57-29-28Z" />
                                                                        </svg>
                                                                    </button> and you can edit the price of the room then modify it.
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Remove Room -->
                                                            <div class="accordion-item">
                                                                <h2 class="accordion-header" id="headingD4">
                                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#faqD4">
                                                                        <span class="text-start text-wrap w-100"> How can I remove a room ?</span>
                                                                    </button>
                                                                </h2>
                                                                <div id="faqD4" class="accordion-collapse collapse" data-bs-parent="#accordionRoom">
                                                                    <div class="accordion-body">
                                                                        Go to the <span class="badge bg-danger"><i class="bi bi-door-closed"></i> Room Information
                                                                        </span> tab,
                                                                        and click the <button type="button"
                                                                                              class="ms-1 btn-red-fill d-inline-flex align-items-center gap-2 px-3 py-1" id="button-delete"
                                                                                              data-bs-toggle="modal" data-bs-target="#modalDeleteRoom">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                                 fill="#e3e3e3">
                                                                                <path
                                                                                    d="M280-120q-33 0-56.5-23.5T200-200v-520h-40v-80h200v-40h240v40h200v80h-40v520q0 33-23.5 56.5T680-120H280Zm400-600H280v520h400v-520ZM360-280h80v-360h-80v360Zm160 0h80v-360h-80v360ZM280-720v520-520Z" />
                                                                            </svg>
                                                                        </button> to remove room.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- View -->
                                                            <div class="accordion-item">
                                                                <h2 class="accordion-header" id="headingD5">
                                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#faqD5">
                                                                        <span class="text-start text-wrap w-100">How can I view the room details ?</span>
                                                                    </button>
                                                                </h2>
                                                                <div id="faqD5" class="accordion-collapse collapse" data-bs-parent="#accordionRoom">
                                                                    <div class="accordion-body">
                                                                        Go to the <span class="badge bg-danger"><i class="bi bi-door-closed"></i> Room Information
                                                                        </span> tab, and
                                                                        click the <button type="button"
                                                                                          class="ms-1 btn-red-fill d-inline-flex align-items-center gap-2 px-3 py-1" id="button-view"
                                                                                          data-bs-toggle="modal" data-bs-target="#modalViewRoomDetails">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" height="14px" viewBox="0 -960 960 960" width="14px"
                                                                                 fill="#FFFFFF">
                                                                                <path
                                                                                    d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z" />
                                                                            </svg>
                                                                        </button> to view the room details of each room type.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                            </div>
                        </div>
                    </div>

                            
                                            
                                            
                                            <!-- Send Inquiry Modal -->
                                            <div class="modal fade" id="modalSendInquiry" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                    <div class="modal-content p-4">
                                                        <!-- Modal Header -->
                                                        <div class="modal-header">
                                                            <p class="modal-title h2 font-red-gradient">Send Inquiry</p>
                                                        </div>
                                                        <!-- Modal Body -->
                                                        <div class="modal-body d-flex flex-column">
                                                            <div class="form-floating mb-3">
                                                                <textarea class="form-control" placeholder="Type your inquiry here..." id="inquiry-message"
                                                                          style="height: 120px" required="required"></textarea>
                                                                <label for="inquiry-message">Message *</label>
                                                            </div>
                                                        </div>
                                                        <!-- Modal Footer -->
                                                        <div class="modal-footer d-flex justify-content-between">
                                                            <div id="error-box-send-inquiry"
                                                                 class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6"
                                                                 style="color:white; background-color: #a6192e;">
                                                                <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                <div>
                                                                    <strong class="fs-5">Warning!</strong><br />
                                                                    <span class="small" id="error-text-send-inquiry"></span>
                                                                </div>
                                                            </div>
                                                            <div class="ms-auto">
                                                                <button type="button" class="btn-red" data-bs-dismiss="modal"
                                                                        id="button-cancel-send-inquiry">Cancel</button>
                                                                <button type="button" class="btn-green-fill" id="button-send-inquiry">Send</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        
                                        <!-- Send Inquiry Confirmation Modal -->
                                        <div class="modal fade" id="modalSendInquiryConfirmation" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    <!-- Modal Header -->
                                                    <div class="modal-header">
                                                        <p class="modal-title h2 font-red-gradient">Send Inquiry Confirmation</p>
                                                    </div>
                                                    <!-- Modal Body -->
                                                    <div class="modal-body d-flex flex-sm-row flex-column">
                                                        <div class="d-flex flex-row">
                                                            <p class="h5 font-red-gradient me-2">Message:</p>
                                                            <p id="confirm-send-inquiry-message" class="font-red"></p>
                                                        </div>
                                                    </div>
                                                    <!-- Modal Footer -->
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalSendInquiry">Cancel</button>
                                                        <button type="button" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalSendInquirySuccess" id="button-confirm-send-inquiry">Confirm</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        
                                        <!-- Send Inquiry Success Modal -->
                                        <div class="modal fade" id="modalSendInquirySuccess" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    <!-- Modal Header -->
                                                    <div class="modal-header d-flex align-items-center justify-content-center">
                                                        <p class="modal-title h2 font-green text-center">Inquiry Sent Successfully!</p>
                                                    </div>
                                                    <!-- Modal Body -->
                                                    <div class="modal-body d-flex align-items-center justify-content-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456">
                                                            <path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/>
                                                        </svg>
                                                    </div>
                                                    <!-- Modal Footer -->
                                                    <div class="modal-footer d-flex align-items-center justify-content-center">
                                                        <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-send-inquiry">Confirm</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        <script>
                                            const translations = {
                                            // RENTER MANAGEMENT
                                            faqA1: {
                                            question: {
                                            en: "How do I add a new renter?",
                                            tl: "Paano ako magdaragdag ng bagong umuupa?"
                                            },
                                            answer: {
                                            en: "Go to the Renter Information tab, click Add Renter and fill in their personal and room details, then save.",
                                            tl: "Pumunta sa tab na Impormasyon ng Umuupa, i-click ang Magdagdag ng Umuupa at punan ang kanilang personal at impormasyon ng kwarto, pagkatapos ay i-save."
                                            }
                                            },
                                            faqA2: {
                                            question: {
                                            en: "Can I edit renter information?",
                                            tl: "Maaari ko bang i-edit ang impormasyon ng umuupa?"
                                            },
                                            answer: {
                                            en: "Yes. Navigate to Renter Information, then click Edit next to the renter’s name and update the details.",
                                            tl: "Oo. Pumunta sa Impormasyon ng Umuupa, pagkatapos ay i-click ang I-edit sa tabi ng pangalan ng umuupa at i-update ang mga detalye."
                                            }
                                            },
                                            faqA3: {
                                            question: {
                                            en: "How do I remove a renter who has moved out?",
                                            tl: "Paano ko aalisin ang umuupang lumipat na?"
                                            },
                                            answer: {
                                            en: "Go to the Renter Information tab, click Delete next to the renter, and confirm the removal.",
                                            tl: "Pumunta sa tab na Impormasyon ng Umuupa, i-click ang Tanggalin sa tabi ng umuupa, at kumpirmahin ang pagtanggal."
                                            }
                                            },
                                            faqA4: {
                                            question: {
                                            en: "How do I search for a specific renter?",
                                            tl: "Paano ako maghahanap ng partikular na umuupa?"
                                            },
                                            answer: {
                                            en: "Use the search bar in the Renter Information tab to filter by name, room number, or contact info.",
                                            tl: "Gamitin ang search bar sa tab ng Impormasyon ng Umuupa para i-filter ayon sa pangalan, numero ng kwarto, o impormasyon sa pakikipag-ugnayan."
                                            }
                                            },
                                            faqA5: {
                                            question: {
                                            en: "How can I view a renter’s stay and payment history?",
                                            tl: "Paano ko makikita ang kasaysayan ng pananatili at bayarin ng umuupa?"
                                            },
                                            answer: {
                                            en: "Navigate to Renter Information, then search the renter’s name. Their profile will display room assignments, move-in/move-out dates, and past billing transactions.",
                                            tl: "Pumunta sa Impormasyon ng Umuupa, pagkatapos ay hanapin ang pangalan ng umuupa. Ipapakita sa kanilang profile ang mga asignasyon ng kwarto, petsa ng paglipat/pag-alis, at mga nakaraang transaksyon sa bayarin."
                                            }
                                            },
                                            
                                            // BILLING &amp; PAYMENTS
                                            faqB1: {
                                            question: {
                                            en: "Can I generate a report?",
                                            tl: "Maaari ba akong gumawa ng ulat?"
                                            },
                                            answer: {
                                            en: "Go to the Billing tab, click Generate Report and you can check and generate some reports.",
                                            tl: "Pumunta sa tab ng Pagsingil, i-click ang Gumawa ng Ulat at maaari kang mag-check at gumawa ng ilang ulat."
                                            }
                                            },
                                            faqB2: {
                                            question: {
                                            en: "Can I view the renter's payment history?",
                                            tl: "Maaari ko bang makita ang kasaysayan ng bayad ng umuupa?"
                                            },
                                            answer: {
                                            en: "Yes, go to Payments tab to view all transactions.",
                                            tl: "Oo, pumunta sa tab na Bayarin upang makita ang lahat ng transaksyon."
                                            }
                                            },
                                            faqB3: {
                                            question: {
                                            en: "How do I mark a payment as received?",
                                            tl: "Paano ko itatala ang bayad bilang natanggap?"
                                            },
                                            answer: {
                                            en: "Navigate to the Payments tab, click Paid to mark as full payment.",
                                            tl: "Pumunta sa tab ng Bayarin, i-click ang Bayad upang markahan bilang ganap na bayad."
                                            }
                                            },
                                            faqB4: {
                                            question: {
                                            en: "How do I check the current electric bill for a renter?",
                                            tl: "Paano ko titingnan ang kasalukuyang bill ng kuryente para sa umuupa?"
                                            },
                                            answer: {
                                            en: "Go to the Billing tab, click Electric Bill and check the renter payment details.",
                                            tl: "Pumunta sa tab ng Pagsingil, i-click ang Bill ng Kuryente at tingnan ang detalye ng bayad ng umuupa."
                                            }
                                            },
                                            faqB5: {
                                            question: {
                                            en: "How do I check the current water bill for a renter?",
                                            tl: "Paano ko titingnan ang kasalukuyang bill ng tubig para sa umuupa?"
                                            },
                                            answer: {
                                            en: "Go to the Billing tab, click Water Bill and check the renter payment details.",
                                            tl: "Pumunta sa tab ng Pagsingil, i-click ang Bill ng Tubig at tingnan ang detalye ng bayad ng umuupa."
                                            }
                                            },
                                            
                                            // TASK MANAGEMENT
                                            faqC1: {
                                            question: {
                                            en: "How do I create a new Task?",
                                            tl: "Paano ako gagawa ng bagong Gawain?"
                                            },
                                            answer: {
                                            en: "Go to the Task Management tab, click Add Task at the top right, then fill out the form with the task title, type, concerned person and due date.",
                                            tl: "Pumunta sa tab ng Pamamahala ng Gawain, i-click ang Magdagdag ng Gawain sa kanang itaas, pagkatapos ay punan ang form."
                                            }
                                            },
                                            faqC2: {
                                            question: {
                                            en: "How do I view past tasks history?",
                                            tl: "Paano ko makikita ang kasaysayan ng mga nakaraang gawain?"
                                            },
                                            answer: {
                                            en: "Navigate to the Task Management tab to review some of the completed past tasks.",
                                            tl: "Pumunta sa tab ng Pamamahala ng Gawain upang suriin ang mga natapos na gawain."
                                            }
                                            },
                                            faqC3: {
                                            question: {
                                            en: "How do I mark a task as completed?",
                                            tl: "Paano ko markahan ang isang gawain bilang natapos?"
                                            },
                                            answer: {
                                            en: "Click the check button in the 'Actions' column of the task list.",
                                            tl: "I-click ang check button sa 'Aksyon' na kolum ng listahan ng gawain."
                                            }
                                            },
                                            faqC4: {
                                            question: {
                                            en: "What happens if a task becomes overdue?",
                                            tl: "Ano ang mangyayari kung ang gawain ay lumampas sa takdang oras?"
                                            },
                                            answer: {
                                            en: "Tasks past their due date will be labeled as Overdue and counted in the 'Overdue Tasks' section.",
                                            tl: "Ang mga gawain na lumampas sa takdang oras ay lalagyan ng tatak na Overdue at bibilangin sa seksyong 'Mga Overdue na Gawain'."
                                            }
                                            },
                                            faqC5: {
                                            question: {
                                            en: "How can I search for a specific task?",
                                            tl: "Paano ako maghahanap ng partikular na gawain?"
                                            },
                                            answer: {
                                            en: "Go to the Task Management tab, and use the search field to search by task ID, title, or person assigned.",
                                            tl: "Pumunta sa tab ng Pamamahala ng Gawain, at gamitin ang search field upang maghanap ng task ID, pamagat, o taong naka-assign."
                                            }
                                            },
                                            
                                            // ROOM MANAGEMENT
                                            faqD1: {
                                            question: {
                                            en: "How do I add a new Room or Unit ?",
                                            tl: "Paano ako magdaragdag ng bagong Kwarto o Yunit?"
                                            },
                                            answer: {
                                            en: "Go to the Room Information tab, and click Add Room then fill out the form.",
                                            tl: "Pumunta sa tab ng Impormasyon ng Kwarto, i-click ang Magdagdag ng Kwarto at punan ang form."
                                            }
                                            },
                                            faqD2: {
                                            question: {
                                            en: "How do I update room availability?",
                                            tl: "Paano ko i-update ang availability ng kwarto?"
                                            },
                                            answer: {
                                            en: "Navigate to the Room Information tab, then click the status to change it.",
                                            tl: "Pumunta sa tab ng Impormasyon ng Kwarto, pagkatapos ay i-click ang status upang baguhin ito."
                                            }
                                            },
                                            faqD3: {
                                            question: {
                                            en: "Can I edit room prices ?",
                                            tl: "Maaari ko bang i-edit ang presyo ng kwarto?"
                                            },
                                            answer: {
                                            en: "Yes, go to Room Information tab, click the edit button and modify the price.",
                                            tl: "Oo, pumunta sa tab ng Impormasyon ng Kwarto, i-click ang edit button at baguhin ang presyo."
                                            }
                                            },
                                            faqD4: {
                                            question: {
                                            en: "How can I remove a room ?",
                                            tl: "Paano ko matatanggal ang isang kwarto?"
                                            },
                                            answer: {
                                            en: "Go to the Room Information tab, and click the delete button to remove the room.",
                                            tl: "Pumunta sa tab ng Impormasyon ng Kwarto, at i-click ang delete button upang tanggalin ang kwarto."
                                            }
                                            },
                                            faqD5: {
                                            question: {
                                            en: "How can I view the room details ?",
                                            tl: "Paano ko makikita ang detalye ng kwarto?"
                                            },
                                            answer: {
                                            en: "Go to the Room Information tab, and click the view button to see room details.",
                                            tl: "Pumunta sa tab ng Impormasyon ng Kwarto, at i-click ang view button upang makita ang detalye ng kwarto."
                                            }
                                            }
                                            };
                                            
                                            document.getElementById('languageSelect').addEventListener('change', function () {
                                            const lang = this.value;
                                            
                                            for (const id in translations) {
                                            const entry = translations[id];
                                            
                                            // Update question
                                            const headerButton = document.querySelector(`#${id}`).closest('.accordion-item').querySelector('.accordion-button span');
                                            if (headerButton) headerButton.textContent = entry.question[lang];
                                            
                                            // Update answer
                                            const answerBody = document.querySelector(`#${id} .accordion-body`);
                                            if (answerBody) answerBody.textContent = entry.answer[lang];
                                            }
                                            });
                                        </script>
                                        
                                    </body>
                                    
                                </html>

    </xsl:template>
</xsl:stylesheet>