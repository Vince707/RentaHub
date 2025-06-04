<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Room Info &#128682; | RentaHub</title>
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
                            $('#room-information-table').DataTable({
                            layout: {
                            bottomStart: {
                            buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                            }
                            }
                            });
                            
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
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-tasks.xml">
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
                                                <a class="nav-link sidebar-nav mt-1 active" href="caretaker-room.xml" id="ledger-nav">
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
                                                <a class="nav-link sidebar-nav mt-1" href="caretaker-help.xml" id="help-nav">
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
                                            <p class="h2 font-red-gradient">Room Information</p>
                                            <div class="d-flex flex-row align-items-center">
                                                <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1" id="room-button-add-room" data-bs-toggle="modal" data-bs-target="#modalAddRoom">
                                                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8E1616"><path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z"/></svg>
                                                    Add Room
                                                </button>
                                            </div>
                                        </div>
                                        <div class="horizontal mt-1 mb-2"></div>
                                        
                                        <!-- TABLE -->
                                        <table class="custom-table" id="room-information-table">
                                            <thead>
                                                <tr>
                                                    <th>Room No.</th>
                                                    <th>Room Type</th>
                                                    <th>Rent Price</th>
                                                    <th class="text-center">Status</th>
                                                    <th class="text-center">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                    <xsl:for-each select="$data//apartmentManagement/rooms/room">
                                        <tr>
                                            <td><xsl:value-of select="roomNo"/></td>
                                            <td><xsl:value-of select="roomType"/></td>
                                            <td>
                                                <xsl:text>PHP </xsl:text>
                                                <xsl:value-of select="format-number(rentPrice, '#,##0.00')"/>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center align-items-center">
                                                    <span class="badge rounded-pill">
                                                        <xsl:choose>
                                                            <xsl:when test="status='Occupied'">
                                                                <xsl:attribute name="class">badge rounded-pill bg-warning</xsl:attribute>
                                                            </xsl:when>
                                                            <xsl:when test="status='Unavailable'">
                                                                <xsl:attribute name="class">badge rounded-pill bg-danger</xsl:attribute>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:attribute name="class">badge rounded-pill bg-success</xsl:attribute>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:value-of select="status"/>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-row justify-content-center align-items-center align-self-center">
                                                    <!-- VIEW button (always shown) -->
                                                    <button
                                                        title="View Room Information"
                                                        type="button"
                                                        class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-view-room"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#modalViewRoomDetails"
                                                        >
                                                        <xsl:attribute name="data-room-id">
                                                            <xsl:value-of select="@id"/>
                                                        </xsl:attribute>
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                                                            <path d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z"/>
                                                        </svg>
                                                    </button>
                                                    
                                                    <!-- EDIT button (hide if status='Unavailable') -->
                                                    <xsl:if test="status != 'Unavailable'">
                                                        <button
                                                            title="Modify Room Information"
                                                            type="button"
                                                            class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-edit-room"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#modalModifyRoom"
                                                            >
                                                            <xsl:attribute name="data-room-id">
                                                                <xsl:value-of select="@id"/>
                                                            </xsl:attribute>
                                                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                                                                <path d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Zm640-584-56-56 56 56Zm-141 85-28-29 57 57-29-28Z"/>
                                                            </svg>
                                                        </button>
                                                    </xsl:if>
                                                    
                                                    <!-- DELETE button (hide if status='Unavailable' or 'Occupied') -->
                                                    <xsl:if test="status != 'Unavailable' and status != 'Occupied'">
                                                        <button
                                                            title="Remove Room"
                                                            type="button"
                                                            class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-delete-room"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#modalDeleteRoomConfirmation"
                                                            >
                                                            <xsl:attribute name="data-room-id">
                                                                <xsl:value-of select="@id"/>
                                                            </xsl:attribute>
                                                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3">
                                                                <path d="M280-120q-33 0-56.5-23.5T200-200v-520h-40v-80h200v-40h240v40h200v80h-40v520q0 33-23.5 56.5T680-120H280Zm400-600H280v520h400v-520ZM360-280h80v-360h-80v360Zm160 0h80v-360h-80v360ZM280-720v520-520Z"/>
                                                            </svg>
                                                        </button>
                                                    </xsl:if>
                                                </div>
                                            </td>
                                              
                                        </tr>
                                    </xsl:for-each>
                                                  
                                                  

                                            </tbody>
                                        </table>
                                        
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Modal Add Room -->
                            <div class="modal fade" id="modalAddRoom" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
                                    <div class="modal-content p-4">
                                        
                                        <!-- Modal Header -->
                                        <div class="modal-header">
                                            <p class="modal-title h2 font-red-gradient">Add Room</p>
                                        </div>
                                        
                                        <!-- Modal body -->
                                        <div class="modal-body d-flex flex-column">
                                            <div class="d-flex flex-row mb-3 flex-wrap">
                                                <div class="form-floating me-2 flex-fill">
                                                    <input type="text" class="form-control" id="add-room-room-number" placeholder="" required="required"/>
                                                        <label for="add-room-room-number">Room Number *</label>
                                                    </div>
                                                    <div class="me-2 mb-3 flex-fill">
                                        <select class="form-select custom-select" id="add-room-floor-number" required="required" style="height: 3.5rem;">
                                            <option selected="selected" disabled="disabled" hidden="hidden">Floor Number *</option>
                                            <option value="1">1st Floor</option>
                                            <option value="2">2nd Floor</option>
                                            <option value="3">3rd Floor</option>
                                            <option value="4">4th Floor</option>
                                            <option value="5">5th Floor</option>
                                            <option value="6">6th Floor</option>
                                            <option value="7">7th Floor</option>
                                            <option value="8">8th Floor</option>
                                            <option value="9">9th Floor</option>
                                            <option value="10">10th Floor</option>
                                            <option value="11">11th Floor</option>
                                            <option value="12">12th Floor</option>
                                            <option value="13">13th Floor</option>
                                            <option value="14">14th Floor</option>
                                            <option value="15">15th Floor</option>
                                            </select>
                                                    </div>
                                                    <div class="me-2 mb-3 flex-fill">
                                        <select class="form-select custom-select" id="add-room-room-type" required="required" style="height: 3.5rem;">
                                            <option selected="selected" disabled="disabled " hidden="hidden">Room Type</option> 
                                            <option value="Studio">Studio</option>
                                            <option value="1BR">1 Bedroom</option>
                                            <option value="2BR">2 Bedrooms</option>
                                        </select>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-row mb-3 flex-wrap">
                                                    <div class="form-floating me-2 flex-fill">
                                                        <input type="text" class="form-control" id="add-room-size" placeholder="" required="required"/>
                                                            <label for="add-room-size">Size/Area (sqm) *</label>
                                                        </div>
                                                        <div class="form-floating me-2 flex-fill">
                                                            <input type="text" class="form-control" id="add-room-rent-price" placeholder="" required="required"/>
                                                                <label for="add-room-rent-price">Rent Price *</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal footer -->
                                                    <div class="modal-footer d-flex justify-content-between">
                                                        <div id="error-box-add-room" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-9" style="color:white; background-color: #a6192e;">
                                                            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                            <div>
                                                                <strong class="fs-5">Warning!</strong><br/>
                                                                <span class="small" id="error-text-add-room"></span>
                                                            </div>
                                                        </div>
                                                        <div class="ms-auto">
                                                            <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-add-room">Cancel</button>
                                                            <button type="button" class="btn-green-fill" id="button-add-room">Add</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Modal Add Room Confirmation -->
                                        <div class="modal fade" id="modalAddRoomConfirmation" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    
                                                    <!-- Modal Header -->
                                                    <div class="modal-header">
                                                        <p class="modal-title h2 font-red-gradient">Add Room Confirmation</p>
                                                    </div>
                                                    
                                                    <!-- Modal body -->
                                                    <div class="modal-body d-flex flex-sm-row flex-column">
                                                        <div class="d-flex flex-column me-5">
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Room Number:</p>
                                                                <p id="confirm-add-room-room-number" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Floor Number:</p>
                                                                <p id="confirm-add-room-floor-number" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Room Type:</p>
                                                                <p id="confirm-add-room-room-type" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Size/Area (sqm):</p>
                                                                <p id="confirm-add-room-size" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Rent Price:</p>
                                                                <p id="confirm-add-room-rent-price" class="font-red"></p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal footer -->
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalAddRoom">Cancel</button>
                                                        <form id="add-room-form" method="POST" action="functions/add-room.php">
                                                            <input type="hidden" name="room_number" id="hidden-add-room-room-number" />
                                                            <input type="hidden" name="floor_number" id="hidden-add-room-floor-number" />
                                                            <input type="hidden" name="room_type" id="hidden-add-room-room-type" />
                                                            <input type="hidden" name="size" id="hidden-add-room-size" />
                                                            <input type="hidden" name="rent_price" id="hidden-add-room-rent-price" />
                                                            <button type="submit" class="btn-green-fill" id="button-confirm-add-room">Confirm</button>
                                                        </form>
                                                          
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Modal Add Room Success -->
                                        <div class="modal fade" id="modalAddRoomSuccess" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    
                                                    <!-- Modal Header -->
                                                    <div class="modal-header d-flex align-items-center justify-content-center">
                                                        <p class="modal-title h2 font-green text-center">New Room Added!</p>
                                                    </div>
                                                    
                                                    <!-- Modal body -->
                                                    <div class="modal-body d-flex align-items-center justify-content-center">
                                <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
                                                    </div>
                                                    
                                                    <!-- Modal footer -->
                                                    <div class="modal-footer d-flex align-items-center justify-content-center">
                                                        <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-add-room">Confirm</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Modal View Room Details -->
                                        <div class="modal fade" id="modalViewRoomDetails" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    
                                                    <!-- Modal Header -->
                                                    <div class="modal-header">
                                                        <p class="modal-title h2 font-red-gradient">Room Details</p>
                                                    </div>
                                                    
                                                    <!-- Modal body -->
                                                    <div class="modal-body d-flex flex-sm-row flex-column">
                                                        <div class="d-flex flex-column me-5">
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Room Number:</p>
                                                                <p id="view-room-room-number" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Floor Number:</p>
                                                                <p id="view-room-floor-number" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Room Type:</p>
                                                                <p id="view-room-room-type" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Size/Area (sqm):</p>
                                                                <p id="view-room-size" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Rent Price:</p>
                                                                <p id="view-room-rent-price" class="font-red"></p>
                                                            </div>
                                                            <div class="d-flex flex-row">
                                                                <p class="h5 font-red-gradient me-2">Status:</p>
                                                                <p id="view-room-status" class="font-red"></p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal footer -->
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalViewRoom">Close</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Modal Modify Room -->
                                        <div class="modal fade" id="modalModifyRoom" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
                                                <div class="modal-content p-4">
                                                    
                                                    <!-- Modal Header -->
                                                    <div class="modal-header">
                                                        <p class="modal-title h2 font-red-gradient">Modify Room</p>
                                                    </div>
                                                    
                                                    <!-- Modal body -->
                                                    <div class="modal-body d-flex flex-column">
                                                        <div class="d-flex flex-row mb-3 flex-wrap">
                                                            <div class="form-floating me-2 flex-fill">
                                                                <input type="text" class="form-control" id="modify-room-room-number" placeholder="" required="required"/>
                                                                    <label for="add-room-room-number">Room Number *</label>
                                                                </div>
                                                                <div class="me-2 mb-3 flex-fill">
                                        <select class="form-select custom-select" id="modify-room-floor-number" required="required" style="height: 3.5rem;">
                                            <option selected="selected" disabled="disabled" hidden="hidden">Floor Number *</option>
                                            <option value="1">1st Floor</option>
                                            <option value="2">2nd Floor</option>
                                            <option value="3">3rd Floor</option>
                                            <option value="4">4th Floor</option>
                                            <option value="5">5th Floor</option>
                                            <option value="6">6th Floor</option>
                                            <option value="7">7th Floor</option>
                                            <option value="8">8th Floor</option>
                                            <option value="9">9th Floor</option>
                                            <option value="10">10th Floor</option>
                                            <option value="11">11th Floor</option>
                                            <option value="12">12th Floor</option>
                                            <option value="13">13th Floor</option>
                                            <option value="14">14th Floor</option>
                                            <option value="15">15th Floor</option>
                                            </select>
                                                                </div>
                                                                <div class="me-2 mb-3 flex-fill">
                                                                    <select class="form-select custom-select" id="modify-room-room-type" required="required" style="height: 3.5rem;">
                                                                        <!-- <option selected="" disabled="disabled " hidden="hidden">Room Type</option>  -->
                                                                        <option value="Studio">Studio</option>
                                                                        <option value="1BR">1 Bedroom</option>
                                                                        <option value="2BR">2 Bedrooms</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="d-flex flex-row mb-3 flex-wrap">
                                                                <div class="form-floating me-2 flex-fill">
                                                                    <input type="text" class="form-control" id="modify-room-size" placeholder="" required="required"/>
                                                                        <label for="modify-room-size">Size/Area (sqm) *</label>
                                                                    </div>
                                                                    <div class="form-floating me-2 flex-fill">
                                                                        <input type="text" class="form-control" id="modify-room-rent-price" placeholder="" required="required"/>
                                                                            <label for="modify-room-rent-price">Rent Price *</label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- Modal footer -->
                                                                <div class="modal-footer d-flex justify-content-between">
                                                                    <div id="error-box-modify-room" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-9" style="color:white; background-color: #a6192e;">
                                                                        <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                        <div>
                                                                            <strong class="fs-5">Warning!</strong><br/>
                                                                            <span class="small" id="error-text-modify-room"></span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="ms-auto">
                                                                        <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-modify-room">Cancel</button>
                                                                        <button type="button" class="btn-green-fill" id="button-modify-room">Modify</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal Modify Room Confirmation -->
                                                    <div class="modal fade" id="modalModifyRoomConfirmation" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                            <div class="modal-content p-4">
                                                                
                                                                <!-- Modal Header -->
                                                                <div class="modal-header">
                                                                    <p class="modal-title h2 font-red-gradient">Modify Room Confirmation</p>
                                                                </div>
                                                                
                                                                <!-- Modal body -->
                                                                <div class="modal-body d-flex flex-sm-row flex-column">
                                                                    <div class="d-flex flex-column me-5">
                                                                        <div class="d-flex flex-row">
                                                                            <p class="h5 font-red-gradient me-2">Room Number:</p>
                                                                            <p id="confirm-modify-room-room-number" class="font-red"></p>
                                                                        </div>
                                                                        <div class="d-flex flex-row">
                                                                            <p class="h5 font-red-gradient me-2">Floor Number:</p>
                                                                            <p id="confirm-modify-room-floor-number" class="font-red"></p>
                                                                        </div>
                                                                        <div class="d-flex flex-row">
                                                                            <p class="h5 font-red-gradient me-2">Room Type:</p>
                                                                            <p id="confirm-modify-room-room-type" class="font-red"></p>
                                                                        </div>
                                                                        <div class="d-flex flex-row">
                                                                            <p class="h5 font-red-gradient me-2">Size/Area (sqm):</p>
                                                                            <p id="confirm-modify-room-size" class="font-red"></p>
                                                                        </div>
                                                                        <div class="d-flex flex-row">
                                                                            <p class="h5 font-red-gradient me-2">Rent Price:</p>
                                                                            <p id="confirm-modify-room-rent-price" class="font-red"></p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- Modal footer -->
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalModifyRoom">Return</button>
                                <form id="form-modify-room" method="POST" action="functions/modify-room.php" >
                                    <input type="hidden" name="room_id" id="hidden-modify-room-room-id" />
                                    <input type="hidden" name="room_number" id="hidden-modify-room-room-number" />
                                    <input type="hidden" name="floor_number" id="hidden-modify-room-floor-number" />
                                    <input type="hidden" name="room_type" id="hidden-modify-room-room-type" />
                                    <input type="hidden" name="size" id="hidden-modify-room-size" />
                                    <input type="hidden" name="rent_price" id="hidden-modify-room-rent-price" />
                                    <button type="submit" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalModifyRoomSuccess" id="button-confirm-modify-room">Confirm</button>
                                </form>
                                                                      

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal Modify Room Success -->
                                                    <div class="modal fade" id="modalModifyRoomSuccess" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                            <div class="modal-content p-4">
                                                                
                                                                <!-- Modal Header -->
                                                                <div class="modal-header d-flex align-items-center justify-content-center">
                                                                    <p class="modal-title h2 font-green text-center">Modify Room Success!</p>
                                                                </div>
                                                                
                                                                <!-- Modal body -->
                                                                <div class="modal-body d-flex align-items-center justify-content-center">
                                <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
                                                                </div>
                                                                
                                                                <!-- Modal footer -->
                                                                <div class="modal-footer d-flex align-items-center justify-content-center">
                                                                    <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-modify-room">Confirm</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Modal Delete Room Confirmation -->
                <div class="modal fade" id="modalDeleteRoomConfirmation" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                        <div class="modal-content p-4">
                            
                            <!-- Modal Header -->
                            <div class="modal-header">
                                <p class="modal-title h2 font-red-gradient">Delete Room Confirmation</p>
                            </div>
                            
                            <!-- Modal body -->
                            <div class="modal-body d-flex flex-sm-row flex-column">
                                <div class="d-flex flex-column me-5">
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-red-gradient me-2">Room Number:</p>
                                        <p id="confirm-remove-room-room-number" class="font-red"></p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-red-gradient me-2">Floor Number:</p>
                                        <p id="confirm-remove-room-floor-number" class="font-red"></p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-red-gradient me-2">Room Type:</p>
                                        <p id="confirm-remove-room-room-type" class="font-red"></p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-red-gradient me-2">Size/Area (sqm):</p>
                                        <p id="confirm-remove-room-size" class="font-red"></p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-red-gradient me-2">Rent Price:</p>
                                        <p id="confirm-remove-room-rent-price" class="font-red"></p>
                                    </div>
                                    <div class="me-2 mb-3 mt-2 flex-fill">
                                        <select class="form-select custom-select" id="remove-room-reason" required="required" style="height: 3.5rem;">
                                            <option value='' selected="selected" disabled="disabled" hidden="hidden">Reason</option> 
                                            <option value="not-available">Not Available</option>
                                            <option value="duplicate-room">Duplicate Room</option>
                                            <option value="under-renovation">Under Renovation</option>
                                            <option value="usage-change">Usage Change</option>
                                            <option value="tenant-request">Tenant Request</option>
                                            <option value="wrong-info">Wrong Info</option>
                                            <option value="room-merged">Room Merged</option>
                                            <option value="other-reason">Other Reason</option>
                                        </select>            
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Modal footer -->
                            <div class="modal-footer d-flex flex-row align-items-end">
                                <div id="error-box-delete-room" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-8" style="color:white; background-color: #a6192e;">
                                    <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                    <div>
                                        <strong class="fs-5">Warning!</strong><br/>
                                        <span class="small" id="error-text-delete-room"></span>
                                    </div>
                                </div>
                                <div class="d-flex flex-row">
                                    <button type="button" class="btn-red me-2" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalDeleteRoom">Cancel</button>
                                    <form id="form-delete-room" method="POST" action="functions/delete-room.php" >
                                        <input type="hidden" name="room_id" id="hidden-delete-room-room-id" />
                                        <input type="hidden" name="delete_reason" id="hidden-delete-room-reason" />
                                    </form>
                                    <button type="button" class="btn-red-fill" id="button-confirm-delete-room">Delete</button>

                                </div>
                                  

                            </div>
                        </div>
                    </div>
                </div>
                                                      
                                                    <!-- Modal Delete Room Success -->
                                                    <div class="modal fade" id="modalDeleteRoomSuccess" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                            <div class="modal-content p-4">
                                                                
                                                                <!-- Modal Header -->
                                                                <div class="modal-header d-flex align-items-center justify-content-center">
                                                                    <p class="modal-title h2 font-green text-center">Delete Room Success!</p>
                                                                </div>
                                                                
                                                                <!-- Modal body -->
                                                                <div class="modal-body d-flex align-items-center justify-content-center">
                                <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
                                                                </div>
                                                                
                                                                <!-- Modal footer -->
                                                                <div class="modal-footer d-flex align-items-center justify-content-center">
                                                                    <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-delete-room">Confirm</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                </body>
                                            </html>

    
    </xsl:template>
</xsl:stylesheet>