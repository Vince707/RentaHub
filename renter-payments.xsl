<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Payments | RentaHub</title>
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
                            }
                
                $(document).ready(function () {
             
                $('#payments-history').DataTable({
                layout: {
                bottomStart: {
                buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                }
                }
                                }); 
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
                                                <a class="nav-link sidebar-nav mt-1" href="renter-billings.xml" id="savings-nav">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                         fill="#FFFFFF">
                                                        <path
                                                            d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
                                                    </svg>
                                                    Billings
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link sidebar-nav mt-1 active" href="renter-payments.xml" id="budgeting-nav">
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
                                    
                                    <!-- Payments Page -->
                                    <div class="main-container h-100 p-4" id="main-container">
                                        <!-- Header -->
                                        <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
                                            <p class="h2 font-red-gradient">Payments</p>
                                            <p class="font-red">as of <span class="current-date"></span> </p>
                                        </div>
                                        <div class="horizontal mt-1 mb-2"></div>
                                        
                            <!-- METRICS -->
                            <div class="row gx-3 gy-3 w-100">
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-white my-0 text-center">Total Unpaid</p>
                                        <p class="h3 font-white my-0 text-center" id="renter-role-total-unpaid">PHP 0.00</p>
                                    </div>
                                </div>
                                
                                
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-white my-0 text-center">Total Payments</p>
                                        <p class="h3 font-white my-0 text-center" id="renter-role-total-payments">PHP 0.00</p>
                                    </div>
                                </div>
                                
                                
                                
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-red my-0 text-center">Total Current Paid</p>
                                        <p class="h3 font-red my-0 text-center" id="renter-role-total-current-paid">PHP 0.00</p>
                                    </div>
                                </div>
                                
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-red my-0 text-center">Overpaid</p>
                                        <p class="h3 font-red my-0 text-center" id="renter-role-overpaid-amount">PHP 0.00</p>
                                    </div>
                                </div>
                                  
                                
                            </div>
                            
                            <div class="col-12 col-sm-6 col-lg-6 mt-4">
                                <div class="red-border d-flex flex-row align-items-center justify-content-between rounded-4 p-3 px-4">
                                    <p class="h6 font-red my-0 me-1 text-center">Overdue</p>
                                    <p class="h3 font-red my-0 me-1 text-center" id="renter-role-overdue-amount">PHP 0.00</p>
                                </div>
                            </div>
                              
                                        
                                        <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-4">
                                            <p class="h3 font-red-gradient me-2">Payment History</p>
                                        </div>
                                        <div class="horizontal mt-1"></div>
                                     
                                            <!-- Table -->
                                            <table class="custom-table mt-3" id="payments-history">
                                                <thead>
                                                    <tr>
                                                        <th>Receipt No.</th>
                                                        <th>Payment Type</th>
                                                        <th>Payment Date</th>
                                                        <th>Amount</th>
                                                        <th>Method</th>
                                                        <th>Remarks</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="payment-history-tbody">
                                                <!-- Rows will be dynamically inserted here -->
                                                </tbody>
                                                <!-- <tbody>
                                                    <tr>
                                                        <td class="text-danger">R25000001</td>
                                                        <td>Water Utility, Rent</td>
                                                        <td>02/12/2025</td>
                                                        <td>PHP 1,281.27</td>
                                                        <td>GCash</td>
                                                        <td>79317644112</td>
                                                        <td><span class="badge rounded-pill bg-success">Full Payment</span></td>
                                                    </tr>
                                                </tbody> -->
                                            </table>
                                                </div>
                                            </div>
                                        </div>
                    
                                </body>
                            </html>

    </xsl:template>
</xsl:stylesheet>