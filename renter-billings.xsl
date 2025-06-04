<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Billings &#128176; | RentaHub</title>
                <link rel="icon" type="image/x-icon" href="images/logo-only.png" />
                
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet"/>
                
                <!-- Bootstrap Icons -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
                
                <!-- DataTables Bootstrap 5 CSS -->
                <link href="https://cdn.datatables.net/2.3.0/css/dataTables.bootstrap5.css" rel="stylesheet"/>
                
                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
                <link href="https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap" rel="stylesheet"/>
                
                <!-- Custom CSS -->
                <link rel="stylesheet" type="text/css" href="styles.css"/>
                
                <!-- jQuery (latest) -->
                <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
                
                <!-- Bootstrap 5 JS Bundle (with Popper) -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
                
                <!-- DataTables JS Core + Bootstrap 5 Integration -->
                <script src="https://cdn.datatables.net/2.3.0/js/dataTables.js"></script>
                <script src="https://cdn.datatables.net/2.3.0/js/dataTables.bootstrap5.js"></script>
                
                <!-- DataTables Buttons Extensions for Export -->
                <script src="https://cdn.datatables.net/buttons/3.2.3/js/dataTables.buttons.js"></script>
                <script src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.dataTables.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
                <script src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.html5.min.js"></script>
                <script src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.print.min.js"></script>
                
                <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js">
                </script>
                
                <!-- Custom JS -->
                <script src="script.js"></script>
            </head>
                        <script>
                // Allowed roles for this page
                const allowedRoles = ['renter'];
                
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
                            }`
                
               
                        </script>
            
            <body class="h-100">
                <!-- Loading Screen -->
                <div id="loading-screen">
                    <div class="spinner"></div>
                    <p>Loading, please wait...</p>
                </div>
                            <audio id="error-sound" src="audio/error.mp3" preload="auto"></audio>
                            
                            <!-- Toggle Button for sm and md screens -->
                            <button class="btn d-block d-xl-none m-3" type="button" data-bs-toggle="offcanvas" data-bs-target="#sideMenuOffcanvas" aria-controls="sideMenuOffcanvas">
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
                                                <a class="nav-link sidebar-nav mt-1" href="renter-dashboard.xml">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z" />
                                                    </svg>
                                                    Dashboard
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1  " href="renter-information.xml">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h168q13-36 43.5-58t68.5-22q38 0 68.5 22t43.5 58h168q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm80-80h280v-80H280v80Zm0-160h400v-80H280v80Zm0-160h400v-80H280v80Zm200-190q13 0 21.5-8.5T510-820q0-13-8.5-21.5T480-850q-13 0-21.5 8.5T450-820q0 13 8.5 21.5T480-790ZM200-200v-560 560Z" />
                                                    </svg>
                                                    Information
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1 active" href="renter-billings.xml" id="savings-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
                                                    </svg>
                                                    Billings
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="renter-payments.xml" id="budgeting-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                                    </svg>
                                                    Payments
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1" href="renter-logout.xml" id="logout-nav">
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
                                            <p class="h2 font-red-gradient">Billings</p>
                                            <div class="d-flex flex-row align-items-center">
                                            </div>
                                        </div>
                                        <div class="horizontal mt-1 mb-2"></div>
                                        <!-- Nav pills -->
                                        <div class="nav-pills-red border-bottom border-3 border-danger">
                                            <ul class="nav nav-pills mt-3">
                                                <li class="nav-item">
                                                    <a class="nav-link active" data-bs-toggle="pill" href="#summary">Summary</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="pill" href="#currentbill">Individual Bill</a>
                                                </li>
                                            </ul>
                                        </div>
                                        
                                        <!-- Tab panes -->
                                        <div class="tab-content">
                                            <div class="tab-pane container active" id="summary">
                                                <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                    <!-- METRICS -->
                                                    <div class="row gx-3 gy-3">
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <p class="h6 font-white my-0">Total Unpaid Bill</p>
                                                                <p class="h3 font-white my-0" id="renter-role-total-unpaid-bill">PHP 0.00</p>
                                                            </div>
                                                        </div>
                                                          
                                                        
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div
                                                                class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <p class="h6 font-white my-0">Total Current Bill</p>
                                                                <p class="h3 font-white my-0" id="renter-role-total-current-bills">PHP 15,283.17</p>
                                                            </div>
                                                        </div>
                                            
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <p class="h6 font-red my-0">Overdue Bills</p>
                                                                <p class="h3 font-red my-0" id="renter-role-overdue-bills">PHP 0.00</p>
                                                            </div>
                                                        </div>
                                            
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div class="red-border d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <svg xmlns="http://www.w3.org/2000/svg" height="56px" viewBox="0 -960 960 960" width="56px" fill="#8B0000">
                                                                    <path d="m422-232 207-248H469l29-227-185 267h139l-30 208ZM320-80l40-280H160l360-520h80l-40 320h240L400-80h-80Zm151-390Z"/>
                                                                </svg>
                                                                <div class="d-flex flex-column align-items-center justify-content-center rounded-4 h-100">
                                                                    <p class="h6 font-red my-0">Total Current Electric Bill</p>
                                                                    <p class="h3 font-red my-0" id="renter-role-total-current-electric-bill">PHP 0.00</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                            
                                            
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div class="red-border d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <svg xmlns="http://www.w3.org/2000/svg" height="56px" viewBox="0 -960 960 960" width="56px" fill="#8B0000">
                                                                    <path d="M491-200q12-1 20.5-9.5T520-230q0-14-9-22.5t-23-7.5q-41 3-87-22.5T343-375q-2-11-10.5-18t-19.5-7q-14 0-23 10.5t-6 24.5q17 91 80 130t127 35ZM480-80q-137 0-228.5-94T160-408q0-100 79.5-217.5T480-880q161 137 240.5 254.5T800-408q0 140-91.5 234T480-80Zm0-80q104 0 172-70.5T720-408q0-73-60.5-165T480-774Q361-665 300.5-573T240-408q0 107 68 177.5T480-160Zm0-320Z"/>
                                                                </svg>
                                                                <div class="d-flex flex-column align-items-center justify-content-center rounded-4 h-100">
                                                                    <p class="h6 font-red my-0">Total Current Water Bill</p>
                                                                    <p class="h3 font-red my-0" id="renter-role-total-current-water-bill">PHP 0.00</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                            
                                            
                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                            <div class="red-border d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                <svg xmlns="http://www.w3.org/2000/svg" height="52px" viewBox="0 -960 960 960" width="52px" fill="#8B0000">
                                                                    <path d="M760-400v-260L560-800 360-660v60h-80v-100l280-200 280 200v300h-80ZM560-800Zm20 160h40v-40h-40v40Zm-80 0h40v-40h-40v40Zm80 80h40v-40h-40v40Zm-80 0h40v-40h-40v40ZM280-220l278 76 238-74q-5-9-14.5-15.5T760-240H558q-27 0-43-2t-33-8l-93-31 22-78 81 27q17 5 40 8t68 4q0-11-6.5-21T578-354l-234-86h-64v220ZM40-80v-440h304q7 0 14 1.5t13 3.5l235 87q33 12 53.5 42t20.5 66h80q50 0 85 33t35 87v40L560-60l-280-78v58H40Zm80-80h80v-280h-80v280Z"/>
                                                                </svg>
                                                                <div class="d-flex flex-column align-items-center justify-content-center rounded-4 h-100">
                                                                    <p class="h6 font-red my-0">Total Current Rent Bill</p>
                                                                    <p class="h3 font-red my-0" id="renter-role-total-current-rent-bill">PHP 0.00</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                          
                                                    
                                                        
                                                        <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-4">
                                                            <p class="h3 font-red-gradient me-2">Billings History</p>
                                                            
                                                        </div>
                                                        <div class="horizontal mt-1"></div>
                                                        
                                                            
                                                            <!-- TABLE -->
                                                            <!-- TODO: XML Connect -->
                                                            <table class="custom-table" id="billings-history-renter-role">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Month Due</th>
                                                                        <th>Electric Bill</th>
                                                                        <th>Water Bill</th>
                                                                        <th>Rent</th>
                                                                        <th>Overdue</th>
                                                                        <th>Total Bill</th>
                                                                        <th>Total Current Unpaid</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                </tbody>
                                                            </table>
                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                
                                <!-- CURRENT BILL SECTION -->
                                <div class="tab-pane container fade" id="currentbill">
                                    <div class="date-input-container m-2 d-flex flex-row" style="transform: translateY(0%);">
                                        <label for="individual-month-due-renter-role" class="date-label">Month Due</label>
                                        <label class="date-input-wrapper ms-2">
                                            <input type="month" id="individual-month-due-renter-role" class="custom-date-input" required="required"/>
                                            <span class="calendar-icon">
                                                <svg xmlns="http://www.w3.org/2000/svg" height="24px"
                                                     viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                                                    <path
                                                        d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                                                </svg>
                                            </span>
                                        </label>
                                    </div>
                                    <!-- METRICS -->
                                    <div class="row gx-3 gy-3">
                                        <div class="col-12 col-sm-6 col-lg-3">
                                            <div class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-white my-0 text-center">Total Unpaid Bill</p>
                                                <p class="h3 font-white my-0 text-center">PHP <span id="individual-total-unpaid-renter-role" class="h3">0.00</span></p>
                                            </div>
                                        </div>
                                        <div class="col-12 col-sm-6 col-lg-3">
                                            <div class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-white my-0 text-center">Total Current Bill</p>
                                                <p class="h3 font-white my-0 text-center">PHP <span id="individual-current-bill-renter-role" class="h3">0.00</span></p>
                                            </div>
                                        </div>
                                        <div class="col-12 col-sm-6 col-lg-3">
                                            <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-red my-0 text-center">Total Current Paid</p>
                                                <p class="h3 font-red my-0 text-center">PHP <span id="individual-current-paid-renter-role" class="h3">0.00</span></p>
                                            </div>
                                        </div>
                                        <div class="col-12 col-sm-6 col-lg-3">
                                            <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-red my-0 text-center">Overpaid</p>
                                                <p class="h3 font-red my-0 text-center">PHP <span id="individual-overpaid-renter-role" class="h3">0.00</span></p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <p class="h4 font-red-gradient mt-2">Individual Breakdown</p>
                                    <div class="d-flex flex-wrap mt-2 justify-content-between">
                                        <!-- Electric Bill -->
                                        <div class="col-12 col-sm-6 col-lg-5 electric-bill-card">
                                            <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4">
                                                <div class="d-flex justify-content-between align-items-start w-100">
                                                    <div class="d-flex align-items-start">
                                                        <p class="h4 font-white mb-3 me-2 align-self-start">Electric Bill</p>
                                                        <svg xmlns="http://www.w3.org/2000/svg" class="align-self-start" height="24px"
                                                             viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                                                            <path
                                                                d="m422-232 207-248H469l29-227-185 267h139l-30 208ZM320-80l40-280H160l360-520h80l-40 320h240L400-80h-80Zm151-390Z" />
                                                        </svg>
                                                    </div>
                                                    <div class="d-flex flex-row">
                                                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1 ms-2"
                                                                data-bs-toggle="modal" data-bs-target="#modalViewElectricInfo">
                                                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                                 fill="#FFFFFF">
                                                                <g transform="scale(1, -1) translate(0, 960)">
                                                                    <path
                                                                        d="M480-120q-33 0-56.5-23.5T400-200q0-33 23.5-56.5T480-280q33 0 56.5 23.5T560-200q0 33-23.5 56.5T480-120Zm-80-240v-480h160v480H400Z" />
                                                                </g>
                                                            </svg>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Reading Date:</p>
                                                    <p class="font-white" id="electric-reading-date-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Due Date:</p>
                                                    <p class="font-white" id="electric-due-date-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Current Reading:</p>
                                                    <p class="font-white" id="electric-current-reading-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Previous Reading:</p>
                                                    <p class="font-white" id="electric-previous-reading-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Consumed Kwh:</p>
                                                    <p class="font-white" id="electric-consumed-kwh-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Amount per Kwh:</p>
                                                    <p class="font-white" id="electric-amount-per-kwh-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row justify-content-between w-100">
                                                    <div class="d-flex flex-row">
                                                        <p class="h4 font-white me-2">Your Bill:</p>
                                                        <p class="font-white" id="electric-your-bill-renter-role"></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Water Bill -->
                                        <div class="col-12 col-sm-6 col-lg-5 water-bill-card">
                                            <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4">
                                                <div class="d-flex justify-content-between align-items-start w-100">
                                                    <div class="d-flex align-items-start">
                                                        <p class="h4 font-white mb-3 me-2 align-self-start">Water Bill</p>
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                             fill="#FFFFFF">
                                                            <path
                                                                d="M491-200q12-1 20.5-9.5T520-230q0-14-9-22.5t-23-7.5q-41 3-87-22.5T343-375q-2-11-10.5-18t-19.5-7q-14 0-23 10.5t-6 24.5q17 91 80 130t127 35ZM480-80q-137 0-228.5-94T160-408q0-100 79.5-217.5T480-880q161 137 240.5 254.5T800-408q0 140-91.5 234T480-80Zm0-80q104 0 172-70.5T720-408q0-73-60.5-165T480-774Q361-665 300.5-573T240-408q0 107 68 177.5T480-160Zm0-320Z" />
                                                        </svg>
                                                    </div>
                                                    <div class="d-flex flex-row">
                                                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1 ms-2"
                                                                data-bs-toggle="modal" data-bs-target="#modalViewWaterInfo">
                                                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                                 fill="#FFFFFF">
                                                                <g transform="scale(1, -1) translate(0, 960)">
                                                                    <path
                                                                        d="M480-120q-33 0-56.5-23.5T400-200q0-33 23.5-56.5T480-280q33 0 56.5 23.5T560-200q0 33-23.5 56.5T480-120Zm-80-240v-480h160v480H400Z" />
                                                                </g>
                                                            </svg>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Reading Date:</p>
                                                    <p class="font-white" id="water-reading-date-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Due Date:</p>
                                                    <p class="font-white" id="water-due-date-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Current Reading:</p>
                                                    <p class="font-white" id="water-current-reading-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Previous Reading:</p>
                                                    <p class="font-white" id="water-previous-reading-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Consumed Cbm:</p>
                                                    <p class="font-white" id="water-consumed-cbm-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Amount per Cbm:</p>
                                                    <p class="font-white" id="water-amount-per-cbm-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row justify-content-between w-100">
                                                    <div class="d-flex flex-row">
                                                        <p class="h4 font-white me-2">Your Bill:</p>
                                                        <p class="font-white" id="water-your-bill-renter-role"></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-12 col-sm-6 col-lg-5 mt-5 rent-bill-card">
                                            <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4">
                                                <div class="d-flex justify-content-between align-items-start w-100">
                                                    <div class="d-flex align-items-start">
                                                        <p class="h4 font-white mb-3 me-2 align-self-start">Rent</p>
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                             fill="#FFFFFF">
                                                            <path
                                                                d="M760-400v-260L560-800 360-660v60h-80v-100l280-200 280 200v300h-80ZM560-800Zm20 160h40v-40h-40v40Zm-80 0h40v-40h-40v40Zm80 80h40v-40h-40v40Zm-80 0h40v-40h-40v40ZM280-220l278 76 238-74q-5-9-14.5-15.5T760-240H558q-27 0-43-2t-33-8l-93-31 22-78 81 27q17 5 40 8t68 4q0-11-6.5-21T578-354l-234-86h-64v220ZM40-80v-440h304q7 0 14 1.5t13 3.5l235 87q33 12 53.5 42t20.5 66h80q50 0 85 33t35 87v40L560-60l-280-78v58H40Zm80-80h80v-280h-80v280Z" />
                                                        </svg>
                                                    </div>
                                                    
                                                   
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Start &amp; Due Date:</p>
                                                    <p class="font-white" id="rent-start-due-date-renter-role"></p>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">End Date:</p>
                                                    <p class="font-white" id="rent-end-date-renter-role"></p>
                                                </div>
                                                <div id="record-payment-breakdown-renter-role" style="margin-top: 0.5em;"></div>
                                                
                                                <div class="d-flex flex-row justify-content-between w-100">
                                                    <div class="d-flex flex-row">
                                                        <p class="h4 font-white me-2">Your Bill:</p>
                                                        <p class="font-white" id="rent-your-bill"></p>
                                                    </div>
                                                    
                                                </div>
                                                
                                            </div>
                                        </div>
                                        
                                        
                                        <div class="col-12 col-sm-6 col-lg-5 mt-5 overdue-bill-card">
                                            <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4">
                                                <div class="d-flex justify-content-between align-items-start w-100">
                                                    <div class="d-flex align-items-start">
                                                        <p class="h4 font-white mb-3 me-2 align-self-start">Overdue Bills</p>
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                             fill="#FFFFFF">
                                                            <path
                                                                d="m40-120 440-760 440 760H40Zm138-80h604L480-720 178-200Zm302-40q17 0 28.5-11.5T520-280q0-17-11.5-28.5T480-320q-17 0-28.5 11.5T440-280q0 17 11.5 28.5T480-240Zm-40-120h80v-200h-80v200Zm40-100Z" />
                                                        </svg>
                                                    </div>
                                                    
                                             
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Electric Overdue:</p>
                                                    <p class="font-white" id="overdue-electric-renter-role"></p>
                                                    <div class="d-flex flex-row ms-5" id="overdue-electric-due-date-container-renter-role" style="display:none;">
                                                        <p class="h6 font-white me-2">Due Date:</p>
                                                        <p class="font-white" id="overdue-electric-due-date-renter-role"></p>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Water Overdue:</p>
                                                    <p class="font-white" id="overdue-water-renter-role"></p>
                                                    <div class="d-flex flex-row ms-5" id="overdue-water-due-date-container-renter-role" style="display:none;">
                                                        <p class="h6 font-white me-2">Due Date:</p>
                                                        <p class="font-white" id="overdue-water-due-date-renter-role"></p>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-row">
                                                    <p class="h6 font-white me-2">Rent Overdue:</p>
                                                    <p class="font-white" id="overdue-rent-renter-role"></p>
                                                    <div class="d-flex flex-row ms-5" id="overdue-rent-due-date-container-renter-role" style="display:none;">
                                                        <p class="h6 font-white me-2">Due Date:</p>
                                                        <p class="font-white" id="overdue-rent-due-date-renter-role"></p>
                                                    </div>
                                                </div>
                                                
                                                <div class="d-flex flex-row justify-content-between w-100">
                                                    <div class="d-flex flex-row">
                                                        <p class="h4 font-white me-2">Your Bill:</p>
                                                        <p class="font-white" id="overdue-total-renter-role"></p>
                                                    </div>
                                                    <!-- <button type="button"
                                                         class="btn-white pay-btn d-flex align-items-center px-3 py-1"
                                                         data-type="Overdue"  
                                                         data-reading-id="1"
                                                         data-renter-id="1"
                                                         data-bs-toggle="modal"
                                                         data-bs-target="#modalRecordPayment">
                                                         Pay
                                                         </button> -->
                                                 </div>
                                                
                                            </div>
                                            </div>
                                    </div>
                                </div>


                        </div></div></div>
                </div>
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                <!-- Modal View Electric Information -->
                <div class="modal fade" id="modalViewElectricInfo" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content p-4">
                            
                            <!-- Modal Header -->
                            <div class="modal-header d-flex align-items-center justify-content-center">
                                <p class="modal-title h2 font-red text-center">Electric Bill Computation</p>
                            </div>
                            
                            <!-- Modal body -->
                            <div class="modal-body d-flex align-items-center justify-content-center">
                                Current Reading - Previous Reading = Consumed Kilowatt per Hour<br />
                                Total Bill / Total Consumed Kilowatt per Hour = Amount per Kilowatt per Hour<br />
                                Consumed Kilowatt per Hour * Amount per Kilowatt per Hour = Your Electric Bill<br />
                            </div>
                            
                            <!-- Modal footer -->
                            <div class="modal-footer d-flex align-items-center justify-content-center">
                                <button type="button" class="btn-red-fill" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Modal View Water Information -->
                <div class="modal fade" id="modalViewWaterInfo" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content p-4">
                            
                            <!-- Modal Header -->
                            <div class="modal-header d-flex align-items-center justify-content-center">
                                <p class="modal-title h2 font-red text-center">Water Bill Computation</p>
                            </div>
                            
                            <!-- Modal body -->
                            <div class="modal-body d-flex flex-column align-items-center justify-content-center">
                                Current Reading - Previous Reading = Consumed Cubic Meter<br />
                                Total Bill / Total Consumed Cubic Meter = Amount per Cubic Meter<br />
                                Consumed Cubic Meter * Amount per Cubic Meter = Your Water Bill<br />
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