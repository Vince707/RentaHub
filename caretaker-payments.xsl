<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Payments &#128176; | RentaHub</title>
                <link rel="icon" type="image/x-icon" href="images/logo-only.png" />
                
                <!-- Bootstrap 5 CSS -->
                <link
                    href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css"
                    rel="stylesheet"/>
                    
                    <!-- Bootstrap Icons -->
                    <link rel="stylesheet"
                          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
                        
                        <!-- DataTables Bootstrap 5 CSS -->
                        <link href="https://cdn.datatables.net/2.3.0/css/dataTables.bootstrap5.css"
                              rel="stylesheet"/>
                            
                            <!-- Google Fonts -->
                            <link rel="preconnect" href="https://fonts.googleapis.com"/>
                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap"
                                        rel="stylesheet"/>
                                        
                                        <!-- Custom CSS -->
                                        <link rel="stylesheet" type="text/css" href="styles.css"/>
                                            
                                            <!-- jQuery (latest) -->
                                            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
                                            
                                            <!-- Bootstrap 5 JS Bundle (with Popper) -->
                                            <script
                                                src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
                                            
                                            <!-- DataTables JS Core + Bootstrap 5 Integration -->
                                            <script src="https://cdn.datatables.net/2.3.0/js/dataTables.js"></script>
                                            <script
                                                src="https://cdn.datatables.net/2.3.0/js/dataTables.bootstrap5.js"></script>
                                            
                                            <!-- DataTables Buttons Extensions for Export -->
                                            <script
                                                src="https://cdn.datatables.net/buttons/3.2.3/js/dataTables.buttons.js"></script>
                                            <script
                                                src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.dataTables.js"></script>
                                            <script
                                                src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
                                            <script
                                                src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
                                            <script
                                                src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
                                            <script
                                                src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.html5.min.js"></script>
                                            <script
                                                src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.print.min.js"></script>
                                            
                                            <!-- Custom JS -->
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
                
                                            $(document).ready(function () {
                                            $('#payments-summary').DataTable({
                                            layout: {
                                            bottomStart: {
                                            buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                                            }
                                            }
                                            });
                                            $('#payments-summary-individual').DataTable({
                                            layout: {
                                            bottomStart: {
                                            buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                                            }
                                            }
                                            });
                                            
                                            });
                                            
                                            
                                            function togglePasswordVisibility(id) {
                                            const passwordField = document.getElementById(id);
                                            const eyeIcon = document.getElementById('eyeIcon');
                                            
                                            const isPassword = passwordField.type === 'password';
                                            passwordField.type = isPassword ? 'text' : 'password';
                                            eyeIcon.className = isPassword ? 'bi bi-eye' : 'bi bi-eye-slash';
                                            }
                
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
                                            <button class="btn d-block d-xl-none m-3" type="button"
                                                    data-bs-toggle="offcanvas" data-bs-target="#sideMenuOffcanvas"
                                                    aria-controls="sideMenuOffcanvas">
                                                <svg xmlns="http://www.w3.org/2000/svg" height="24px"
                                                     viewBox="0 -960 960 960" width="24px" fill="#8E1616">
                                                    <path
                                                        d="M120-240v-80h720v80H120Zm0-200v-80h720v80H120Zm0-200v-80h720v80H120Z" />
                                                </svg>
                                            </button>
                                            <div class="container-fluid h-100">
                                                <div class="row h-100">
                                                    <!--SIDE MENU LG-->
                                                    <div
                                                        class="offcanvas-xl offcanvas-start d-xl-flex flex-column p-0 bg-light shadow-lg side-menu position-fixed top-0 h-100 align-items-start border-end rounded-end-4"
                                                        tabindex="-1" id="sideMenuOffcanvas"
                                                                  aria-labelledby="sideMenuOffcanvasLabel">
                                                        <div style="
                                                                background-color: white;
                                                                position: relative;
                                                                min-width: 37vh;
                                                                max-width: 37vh;
                                                                width: 37vh;
                                                                border-top-right-radius: 1rem;
                                                                " class="border-end col-sm-2 p-0 m-0">
                                                            <img src="images/menu-logo.png" alt="RentaHub Logo"
                                                                 class="d-block img-fluid" />
                                                        </div>
                                                        <ul class="nav nav-pills nav-justified flex-column w-100 pt-4">
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1"
                                                                   href="caretaker-dashboard.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
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
                                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-tasks.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h168q13-36 43.5-58t68.5-22q38 0 68.5 22t43.5 58h168q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm80-80h280v-80H280v80Zm0-160h400v-80H280v80Zm0-160h400v-80H280v80Zm200-190q13 0 21.5-8.5T510-820q0-13-8.5-21.5T480-850q-13 0-21.5 8.5T450-820q0 13 8.5 21.5T480-790ZM200-200v-560 560Z" />
                                                                    </svg>
                                                                    Tasks
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-renter.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M40-160v-112q0-34 17.5-62.5T104-378q62-31 126-46.5T360-440q66 0 130 15.5T616-378q29 15 46.5 43.5T680-272v112H40Zm720 0v-120q0-44-24.5-84.5T666-434q51 6 96 20.5t84 35.5q36 20 55 44.5t19 53.5v120H760ZM360-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47Zm400-160q0 66-47 113t-113 47q-11 0-28-2.5t-28-5.5q27-32 41.5-71t14.5-81q0-42-14.5-81T544-792q14-5 28-6.5t28-1.5q66 0 113 47t47 113ZM120-240h480v-32q0-11-5.5-20T580-306q-54-27-109-40.5T360-360q-56 0-111 13.5T140-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T440-640q0-33-23.5-56.5T360-720q-33 0-56.5 23.5T280-640q0 33 23.5 56.5T360-560Zm0 320Zm0-400Z" />
                                                                    </svg>
                                                                    Renter Information
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-room.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M120-120v-80h80v-640h400v40h160v600h80v80H680v-600h-80v600H120Zm160-640v560-560Zm160 320q17 0 28.5-11.5T480-480q0-17-11.5-28.5T440-520q-17 0-28.5 11.5T400-480q0 17 11.5 28.5T440-440ZM280-200h240v-560H280v560Z" />
                                                                    </svg>
                                                                    Room Information
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1"
                                                                   href="caretaker-billings.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
                                                                    </svg>
                                                                    Billings
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1 active"
                                                                   href="caretaker-payments.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                                                    </svg>
                                                                    Payments
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-help.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M478-240q21 0 35.5-14.5T528-290q0-21-14.5-35.5T478-340q-21 0-35.5 14.5T428-290q0 21 14.5 35.5T478-240Zm-36-154h74q0-33 7.5-52t42.5-52q26-26 41-49.5t15-56.5q0-56-41-86t-97-30q-57 0-92.5 30T342-618l66 26q5-18 22.5-39t53.5-21q32 0 48 17.5t16 38.5q0 20-12 37.5T506-526q-44 39-54 59t-10 73Zm38 314q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z" />
                                                                    </svg>
                                                                    Help
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link sidebar-nav mt-1" href="logout.xml">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1"
                                                                         height="24px" viewBox="0 -960 960 960" width="24px"
                                                                         fill="#FFFFFF">
                                                                        <path
                                                                            d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h280v80H200Zm440-160-55-58 102-102H360v-80h327L585-622l55-58 200 200-200 200Z" />
                                                                    </svg>
                                                                    Log Out
                                                                </a>
                                                            </li>
                                                        </ul>
                                                        <div
                                                            class="d-flex mt-auto align-items-center align-self-center flex-column">
                                                            <p
                                                                class="small align-self-center fw-bold mb-0 pb-0 current-date"></p>
                                                            <p class="align-self-center pt-0 mt-0" style="font-size: 0.6rem">
                                                                &#169; <span class="current-year"></span> RentaHub. All Rights
                                                                Reserved.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <!-- MAIN CONTENT -->
                                                    <div class="main-container h-100 p-4" id="main-container">
                                                        <div
                                                            class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
                                                            <p class="h2 font-red-gradient">Payments</p>
                                                            <div class="d-flex flex-row align-items-center">
                                                                <button type="button"
                                                                        class="btn-red d-flex align-items-center px-3 py-1"
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#modalRecordPayment">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" height="24px"
                                                                         viewBox="0 -960 960 960" width="24px"
                                                                         fill="#891B1B">
                                                                        <path
                                                                            d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                                                    </svg>
                                                                    Record Payment
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <div class="horizontal mt-1 mb-2"></div>
                                                        <!-- Nav pills -->
                                                        <div class="nav-pills-red border-bottom border-3 border-danger">
                                                            <ul class="nav nav-pills mt-3">
                                                                <li class="nav-item">
                                                                    <a class="nav-link active" data-bs-toggle="pill"
                                                                       href="#summary">Summary</a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a class="nav-link" data-bs-toggle="pill"
                                                                       href="#individual">Individual</a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        
                                                        <div class="tab-content">
                                                            
                                                            <div class="tab-pane container active" id="summary">
                                                                <div
                                                                    class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                                    
                                                                    <!-- METRICS -->
                                                                    <div class="row gx-3 gy-3">
                                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                                            <div
                                                                                class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                <p class="h6 font-white my-0">Total Unpaid</p>
                                                                                <p class="h3 font-white my-0" id="total-unpaid-in-payments">PHP 7,208.28</p>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                                            <div
                                                                                class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                <p class="h6 font-white my-0">Total Current Payments</p>
                                                                                <p class="h3 font-white my-0" id="total-current-in-payments">PHP 7,208.28</p>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <div class="col-12 col-sm-6 col-lg-4">
                                                                            <div
                                                                                class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                <p class="h6 font-red my-0">Overdues</p>
                                                                                <p class="h3 font-red my-0" id="total-overdue-in-payments">2</p>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <p class="h3 font-red-gradient me-2">Payments History</p>
                                                                        
                                                                        <div class="horizontal mt-1"></div>
                                                                        <!-- TABLE -->
                                                                        <!-- TODO: XML Connect -->
                                                                        <table class="custom-table" id="payments-summary">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Receipt No.</th>
                                                                                    <th>Room No.</th>
                                                                                    <th>Renter Name</th>
                                                                                    <th>Payment Date</th>
                                                                                    <th>Payment Amount</th>
                                                                                    <th>Payment Type</th>
                                                                                    <th>Payment Amount Type</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                    <xsl:for-each select="$data//apartmentManagement/payments/payment">
                                                        <tr>
                                                            <td><xsl:value-of select="@id"/></td>
                                                            
                                                            <!-- Get Room Number from renter information -->
                                                            <td>
                                                                <xsl:variable name="renterId" select="renterId"/>
                                                                <xsl:value-of select="$data//apartmentManagement/renters/renter[@id=$renterId]/roomNo"/>
                                                            </td>
                                                            
                                                            <!-- Renter Name -->
                                                            <td>
                                                                <xsl:variable name="renter" select="$data//apartmentManagement/renters/renter[@id=current()/renterId]"/>
                                                                <xsl:value-of select="$renter/personalInfo/name/firstName"/>
                                                                <xsl:text> </xsl:text>
                                                                <xsl:value-of select="$renter/personalInfo/name/middleName"/>
                                                                <xsl:if test="$renter/personalInfo/name/middleName != ''">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                                <xsl:value-of select="$renter/personalInfo/name/surname"/>
                                                                <xsl:if test="$renter/personalInfo/name/extension != ''">
                                                                    <xsl:text> </xsl:text>
                                                                    <xsl:value-of select="$renter/personalInfo/name/extension"/>
                                                                </xsl:if>
                                                            </td>
                                                            
                                                            <!-- Formatted Payment Date -->
                                                            <td>
                                                                <xsl:value-of select="concat(
                                                                                      substring(paymentDate, 6, 2), '/',
                                                                                      substring(paymentDate, 9, 2), '/',
                                                                                      substring(paymentDate, 1, 4)
                                                                                      )"/>
                                                            </td>
                                                            
                                                            <!-- Formatted Payment Amount -->
                                                            <td>
                                                                <xsl:text>PHP </xsl:text>
                                                                <xsl:value-of select="format-number(amount, '#,##0.00')"/>
                                                            </td>
                                                            
                                                            <td><xsl:value-of select="paymentType"/></td>
                                                            
                                                            <!-- Payment Amount Type with suffix -->
                                                            <td>
                                                                <xsl:value-of select="paymentAmountType"/>
                                                                <xsl:text> Payment</xsl:text>
                                                            </td>
                                                        </tr>
                                                    </xsl:for-each>
                                                                                
                                                                            </tbody>
                                                                        </table>
                                                                        
                                                                    </div>
                                                                </div>
                                                                
                                                            </div>
                                                            <div class="tab-pane container" id="individual">
                                                                <div
                                                                    class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                                                                    <!-- TODO: Populate from XML -->
                                                                    <div class="d-flex flex-column align-items-start w-100">
                                                                        <select class="form-select custom-select select-sort"
                                                                                id="select-payments-renter">
                                                                            <option selected="selected" disabled="disabled " hidden="hidden">Renter</option>
                                                                            <option value="userid">Dave Alon</option>
                                                                        </select>
                                                                        <p class="font-red mt-2">As of <span
                                                                                class="current-date"></span></p>
                                                                        
                                                                        <!-- METRICS -->
                                                                        <div class="row gx-3 gy-3 w-100">
                                                                            <div class="col-12 col-sm-6 col-lg-3">
                                                                                <div
                                                                                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                    <p class="h6 font-white my-0 text-center">Total
                                                                                        Unpaid</p>
                                                                                    <p class="h3 font-white my-0 text-center">PHP
                                                                                        7,208.28</p>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            <div class="col-12 col-sm-6 col-lg-3">
                                                                                <div
                                                                                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                    <p class="h6 font-white my-0 text-center">Total Current
                                                                                        Inflows</p>
                                                                                    <p class="h3 font-white my-0 text-center">PHP
                                                                                        7,208.28</p>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            <div class="col-12 col-sm-6 col-lg-3">
                                                                                <div
                                                                                    class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                    <p class="h6 font-red my-0 text-center">Total Current
                                                                                        Paid</p>
                                                                                    <p class="h3 font-red my-0 text-center">PHP 7,208.28</p>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            <div class="col-12 col-sm-6 col-lg-3">
                                                                                <div
                                                                                    class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                                                    <p class="h6 font-red my-0 text-center">Overpaid</p>
                                                                                    <p class="h3 font-red my-0 text-center">PHP 7,208.28</p>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                        </div>
                                                                        
                                                                        <div class="col-12 col-sm-6 col-lg-6 mt-4">
                                                                            <div
                                                                                class="red-border d-flex flex-row align-items-center justify-content-between rounded-4 p-3 px-4 h-100">
                                                                                <p class="h6 font-red my-0 me-1 text-center">Overdue</p>
                                                                                <p class="h3 font-red my-0 me-1 text-center">PHP
                                                                                    7,208.28</p>
                                                                                <button type="button" class="btn-red-fill"
                                                                                        data-bs-toggle="modal"
                                                                                        data-bs-target="#modalSendNotificationConfirmation">Notify</button>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <p class="h3 font-red-gradient me-2 mt-3">Payments History</p>
                                                                        <div class="horizontal mt-1 w-100"></div>
                                                                        
                                                                        <!-- TABLE -->
                                                                        <!-- TODO: XML Connect -->
                                                                        <table class="custom-table" id="payments-summary-individual">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Receipt No.</th>
                                                                                    <th>Room No.</th>
                                                                                    <th>Renter Name</th>
                                                                                    <th>Payment Date</th>
                                                                                    <th>Payment Amount</th>
                                                                                    <th>Payment Type</th>
                                                                                    <th>Payment Amount Type</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>R25000001</td>
                                                                                    <td>1A</td>
                                                                                    <td>Dave Alon</td>
                                                                                    <td>02/12/2025</td>
                                                                                    <td>PHP 4,291.18</td>
                                                                                    <td>Rent</td>
                                                                                    <td>Full Payment</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        
                                                                    </div>
                                                                    
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                                            
                                                            <!-- Modal Record Payment -->
  <div class="modal fade" id="modalRecordPayment" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header d-flex flex-column align-items-start">
          <p class="modal-title h2 font-red-gradient">Record
            Payment</p>
          <p class="modal-title h4 font-red-gradient" id="record-payment-receipt-number"></p>
        </div>

        <!-- Modal body -->
        <div class="modal-body">
          <div class="d-flex flex-column">
            <select class="form-select custom-select select-sort me-1 col-1" id="record-payment-renter">
              <option selected="selected" disabled="disabled" hidden="hidden">Renter Name *</option>
              <xsl:for-each select="$data//apartmentManagement/renters/renter[status='Active']">
                    <option value="{userId}">
                      <xsl:value-of select="personalInfo/name/firstName"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="personalInfo/name/middleName"/>
                      <xsl:if test="personalInfo/name/middleName"> </xsl:if>
                        <xsl:text> </xsl:text>
                      <xsl:value-of select="personalInfo/name/surname"/>
                      <xsl:if test="personalInfo/name/extension">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="personalInfo/name/extension"/>
                      </xsl:if>
                    </option>
                  </xsl:for-each>
            </select>
            <p class="h4 font-red-gradient mt-3">Payment Type</p>
            <div class="d-flex flex-row">
              <label class="custom-checkbox-container me-2">
                <input type="checkbox" class="custom-checkbox" id="record-payment-electric-checkbox"/>
                Electricity
              </label>
              <label class="custom-checkbox-container me-2">
                <input type="checkbox" class="custom-checkbox" id="record-payment-water-checkbox"/>
                Water
              </label>
              <label class="custom-checkbox-container me-2">
                <input type="checkbox" class="custom-checkbox" id="record-payment-rent-checkbox"/>
                Rent
              </label>
            </div>
            <p class="h4 font-red-gradient mt-3">Payment Details</p>
            <div class="date-input-container me-2 mt-3 flex-fill" style="transform: translateX(0);">
              <label for="record-payment-payment-date" class="date-label">Payment Date <span>*</span></label>
              <label class="date-input-wrapper">
                <input type="date" id="record-payment-payment-date" class="custom-date-input" required="required"/>
                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px"
                    viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                    <path
                      d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                  </svg></span>
              </label>
            </div>
            <div class="form-floating me-2 flex-fill mt-3">
              <input type="text" class="form-control" id="record-payment-payment-amount" placeholder="placeholder" required="required"/>
              <label for="record-payment-payment-amount">Payment
                Amount *</label>
            </div>
            <select class="form-select custom-select select-sort me-1 col-1 mt-3" id="record-payment-method">
              <option selected="selected" disabled="disabled" hidden="hidden" value="">Payment Method
                *</option>
              <option value="cash">Cash</option>
              <option value="gcash">GCash</option>
            </select>
            <select class="form-select custom-select select-sort me-1 col-1 mt-3" id="record-payment-amount-type">
              <option selected="selected" disabled="disabled" hidden="hidden" value="">Payment Amount Type
                *</option>
              <option value="full">Full Payment</option>
              <option value="partial">Partial Payment</option>
            </select>
            <div class="form-floating me-2 flex-fill mt-3">
              <input type="text" class="form-control" id="record-payment-remarks" placeholder="placeholder" required="required"/>
              <label for="record-payment-remarks">Remarks</label>
            </div>
          </div>
        </div>

        <!-- Modal footer -->
        <div class="modal-footer d-flex align-items-end">
          <div id="error-box-record-payment" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6" style="color:white; background-color: #a6192e;">
            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
            <div>
              <strong class="fs-5">Warning!</strong><br/>
              <span class="small" id="error-text-record-payment"></span>
            </div>
          </div>
          <div class="ms-auto">
            <button type="button" class="btn-red"
            data-bs-dismiss="modal">Cancel</button>
          <button type="button" class="btn-green-fill"
            id="button-record-payment">Record</button>
          </div>
        </div>
      </div>
    </div>
  </div>


  <!-- Modal Record Payment Confirmation-->
  <div class="modal fade" id="modalRecordPaymentConfirmation" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header d-flex align-items-center justify-content-center">
          <p class="modal-title h2 font-red text-center">Record
            Payment Confirmation</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Receipt No:</p>
            <p id="confirm-record-receipt-number" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Renter ID:</p>
            <p id="confirm-record-renter-id" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Payment Type:</p>
            <p id="confirm-record-payment-type" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Payment Date:</p>
            <p id="confirm-record-payment-date" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Payment Amount:</p>
            <p id="confirm-record-payment-amount" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Payment Method:</p>
            <p id="confirm-record-payment-method" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Payment Amount
              Type:</p>
            <p id="confirm-record-payment-amount-type" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Remarks:</p>
            <p id="confirm-record-payment-remarks" class="font-red"></p>
          </div>

        </div>

        <!-- Modal footer -->
        <div class="modal-footer d-flex align-items-center justify-content-center">
          <button type="button" class="btn-red" data-bs-dismiss="modal">Cancel</button>
            <form id="hidden-payment-form" method="post" action="functions/pay.php">
              <input type="hidden" id="hidden-record-bill-id" name="bill_id" />
              <input type="hidden" id="hidden-record-reading-id" name="reading_id" />
              <input type="hidden" id="hidden-record-overdue-bill-ids" name="overdue_bill_ids" />
              <input type="hidden" id="hidden-record-receipt-number" name="receipt_number" />
              <input type="hidden" id="hidden-record-renter-id" name="renter_id" />
              <input type="hidden" id="hidden-record-payment-type" name="payment_type" />
              <input type="hidden" id="hidden-record-payment-date" name="payment_date" />
              <input type="hidden" id="hidden-record-payment-amount" name="payment_amount" />
              <input type="hidden" id="hidden-record-payment-method" name="payment_method" />
              <input type="hidden" id="hidden-record-payment-amount-type" name="payment_amount_type" />
              <input type="hidden" id="hidden-record-payment-remarks" name="payment_remarks" />
              <button type="submit" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal"
               data-bs-target="#modalRecordPaymentSuccess" id="button-confirm-record-payment">Confirm</button>
            </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Record Payment Success -->
  <div class="modal fade" id="modalRecordPaymentSuccess" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header d-flex align-items-center justify-content-center">
          <p class="modal-title h2 font-green text-center">Payment
            Recorded Successfully!</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex align-items-center justify-content-center">
          <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456">
            <path
              d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z" />
          </svg>
        </div>

        <!-- Modal footer -->
        <div class="modal-footer d-flex flex-column align-items-center justify-content-center">
          <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-record-payment-notify"
            data-bs-toggle="modal" data-bs-target="#modalSendNotificationSuccess">Confirm &amp;
            Notify</button>
          <button type="button" class="btn-green" data-bs-dismiss="modal"
            id="button-success-record-payment">Confirm</button>
        </div>
      </div>
    </div>
  </div>

                                                                                    <!-- Modal Send Notification Confirmation -->
                                                                                    <div class="modal fade" id="modalSendNotificationConfirmation"
                                                                                         tabindex="-1">
                                                                                        <div class="modal-dialog modal-dialog-centered modal-lg">
                                                                                            <div class="modal-content p-4">
                                                                                                
                                                                                                <!-- Modal Header -->
                                                                                                <div
                                                                                                    class="modal-header d-flex align-items-center justify-content-center">
                                                                                                    <p class="modal-title h2 font-red text-center">Confirm Send
                                                                                                        Notification?</p>
                                                                                                </div>
                                                                                                
                                                                                                <!-- Modal body -->
                                                                                                <div
                                                                                                    class="modal-body d-flex align-items-center justify-content-center">
                                                                                                    <!-- TODO: NAME -->
                                                                                                    Do you want to notify David Alon?
                                                                                                </div>
                                                                                                
                                                                                                <!-- Modal footer -->
                                                                                                <div
                                                                                                    class="modal-footer d-flex align-items-center justify-content-center">
                                                                                                    <button type="button" class="btn-red"
                                                                                                            data-bs-dismiss="modal">Cancel</button>
                                                                                                    <button type="button" class="btn-green-fill"
                                                                                                            id="button-confirm-send-notif">Confirm</button>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    
                                                                                    <!-- Modal Send Notification Success -->
                                                                                    <div class="modal fade" id="modalSendNotificationSuccess"
                                                                                         tabindex="-1">
                                                                                        <div class="modal-dialog modal-dialog-centered modal-md">
                                                                                            <div class="modal-content p-4">
                                                                                                
                                                                                                <!-- Modal Header -->
                                                                                                <div
                                                                                                    class="modal-header d-flex align-items-center justify-content-center">
                                                                                                    <p class="modal-title h2 font-green text-center">Renter
                                                                                                        Notified Successfully!</p>
                                                                                                </div>
                                                                                                
                                                                                                <!-- Modal body -->
                                                                                                <div
                                                                                                    class="modal-body d-flex align-items-center justify-content-center">
                                                                                                    <svg xmlns="http://www.w3.org/2000/svg" height="200px"
                                                                                                         viewBox="0 -960 960 960" width="200px"
                                                                                                         fill="#6EC456">
                                                                                                        <path
                                                                                                            d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z" />
                                                                                                    </svg>
                                                                                                </div>
                                                                                                
                                                                                                <!-- Modal footer -->
                                                                                                <div
                                                                                                    class="modal-footer d-flex align-items-center justify-content-center">
                                                                                                    <button type="button" class="btn-green-fill"
                                                                                                            data-bs-dismiss="modal">Confirm</button>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    
                                                                                </body>
                                                                                
                                                                            </html>
    </xsl:template>
</xsl:stylesheet>