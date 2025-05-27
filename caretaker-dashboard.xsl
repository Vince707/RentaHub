<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
            
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Dashboard &#128202; | RentaHub</title>
                
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
                <!--CHARTS-->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
                
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
                                    <a class="nav-link sidebar-nav mt-1 active" href="caretaker-dashboard.xml">
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
                                    <a class="nav-link sidebar-nav mt-1" href="caretaker-renter.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#FFFFFF">
                                            <path
                                                d="M40-160v-112q0-34 17.5-62.5T104-378q62-31 126-46.5T360-440q66 0 130 15.5T616-378q29 15 46.5 43.5T680-272v112H40Zm720 0v-120q0-44-24.5-84.5T666-434q51 6 96 20.5t84 35.5q36 20 55 44.5t19 53.5v120H760ZM360-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47Zm400-160q0 66-47 113t-113 47q-11 0-28-2.5t-28-5.5q27-32 41.5-71t14.5-81q0-42-14.5-81T544-792q14-5 28-6.5t28-1.5q66 0 113 47t47 113ZM120-240h480v-32q0-11-5.5-20T580-306q-54-27-109-40.5T360-360q-56 0-111 13.5T140-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T440-640q0-33-23.5-56.5T360-720q-33 0-56.5 23.5T280-640q0 33 23.5 56.5T360-560Zm0 320Zm0-400Z" />
                                        </svg>
                                        Renter Information
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link sidebar-nav mt-1" href="caretaker-room.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#FFFFFF">
                                            <path
                                                d="M120-120v-80h80v-640h400v40h160v600h80v80H680v-600h-80v600H120Zm160-640v560-560Zm160 320q17 0 28.5-11.5T480-480q0-17-11.5-28.5T440-520q-17 0-28.5 11.5T400-480q0 17 11.5 28.5T440-440ZM280-200h240v-560H280v560Z" />
                                        </svg>
                                        Room Information
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link sidebar-nav mt-1" href="caretaker-billings.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#FFFFFF">
                                            <path
                                                d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
                                        </svg>
                                        Billings
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link sidebar-nav mt-1" href="caretaker-payments.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#FFFFFF">
                                            <path
                                                d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                        </svg>
                                        Payments
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link sidebar-nav mt-1" href="caretaker-help.xml">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#FFFFFF">
                                            <path
                                                d="M478-240q21 0 35.5-14.5T528-290q0-21-14.5-35.5T478-340q-21 0-35.5 14.5T428-290q0 21 14.5 35.5T478-240Zm-36-154h74q0-33 7.5-52t42.5-52q26-26 41-49.5t15-56.5q0-56-41-86t-97-30q-57 0-92.5 30T342-618l66 26q5-18 22.5-39t53.5-21q32 0 48 17.5t16 38.5q0 20-12 37.5T506-526q-44 39-54 59t-10 73Zm38 314q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z" />
                                        </svg>
                                        Help
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link sidebar-nav mt-1" href="logout.xml">
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
                                <p class="h2 font-red-gradient">Dashboard</p>
                                <div class="d-flex flex-row align-items-center">
                                    <button type="button" class="btn-red d-flex align-items-center px-3 py-1" id="dashboard-button-add-renter"
                                            data-bs-toggle="modal" data-bs-target="#modalAddRenter">
                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#8E1616">
                                            <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
                                        </svg>
                                        Add Renter
                                    </button>
                                    <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1"
                                            id="dashboard-button-record-payment" data-bs-toggle="modal" data-bs-target="#modalRecordPayment">
                                        <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                                                fill="#8E1616">
                                            <path
                                                d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
                                        </svg>
                                        Record Payment
                                    </button>
                                </div>
                            </div>
                            <div class="horizontal mt-1 mb-2"></div>
                            <!-- METRICS -->
                            <div class="row gx-3 gy-3">
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="gradient-red-bg d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h1 font-white my-0" id="total-renters-accounts">0</p>
                                        <p class="h6 font-white ms-3 my-0">Total Renters</p>
                                    </div>
                                </div>
                                
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="gradient-red-bg d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-white my-0">Total Payments</p>
                                        <p class="h3 font-white my-0" id="total-payments">PHP 0.00</p>
                                    </div>
                                </div>
                                
                                
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-red my-0">Overdue Renters</p>
                                        <p class="h3 font-red my-0" id="total-overdue-renters">0</p>
                                    </div>
                                </div>
                                
                                
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-red my-0">Collection Rate</p>
                                        <p class="h3 font-red my-0" id="collection-rate">0%</p>
                                    </div>
                                </div>
                                
                                
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-red my-0 text-center">On-Time Payment Rate</p>
                                        <p class="h3 font-red my-0" id="on-time-payment-rate">0%</p>
                                    </div>
                                </div>
                                
                                
                                <div class="col-12 col-sm-6 col-lg-4">
                                    <div class="gradient-red-bg d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                        <p class="h6 font-white my-0">Total Current Bills</p>
                                        <p class="h3 font-white my-0" id="total-current-bills">PHP 0.00</p>
                                    </div>
                                </div>
                                  
                            </div>
                            
                            <!-- GRAPH -->
                            <div class="container-fluid d-flex">
                                <p class="h2 font-red-gradient mx-auto mt-5">
                                    Total Payments Collected (PHP)
                                </p>
                            </div>
                            <canvas id="totalPaymentsChart" class="container-fluid"></canvas>
                            <script>
                                $(document).ready(function () {
                                // Helper: Aggregate payments by month (0=Jan, 11=Dec)
                                function aggregateMonthlyPayments(payments) {
                                const monthlyTotals = new Array(12).fill(0);
                                for (const id in payments) {
                                if (payments.hasOwnProperty(id)) {
                                const payment = payments[id];
                                if (!payment.paymentDate || !payment.amount) continue;
                                
                                const date = new Date(payment.paymentDate);
                                if (isNaN(date)) continue;
                                
                                const monthIndex = date.getMonth();
                                const amount = parseFloat(payment.amount.replace(/[^0-9.-]+/g, '')) || 0;
                                
                                monthlyTotals[monthIndex] += amount;
                                }
                                }
                                return monthlyTotals;
                                }
                                
                                const paymentsMap = {};
                                
                                $.ajax({
                                url: 'apartment.xml', // Replace with your actual XML URL
                                dataType: 'xml',
                                success: function (xml) {
                                $(xml).find('payments > payment').each(function () {
                                const id = $(this).attr('id');
                                paymentsMap[id] = {
                                renterId: $(this).find('renterId').text().trim(),
                                paymentType: $(this).find('paymentType').text().trim(),
                                paymentAmountType: $(this).find('paymentAmountType').text().trim(),
                                paymentDate: $(this).find('paymentDate').text().trim(),
                                amount: $(this).find('amount').text().trim(),
                                paymentMethod: $(this).find('paymentMethod').text().trim(),
                                remarks: $(this).find('remarks').text().trim()
                                };
                                });
                                
                                const monthlyTotals = aggregateMonthlyPayments(paymentsMap);
                                
                                const monthLabels = [
                                "January", "February", "March", "April", "May", "June",
                                "July", "August", "September", "October", "November", "December"
                                ];
                                
                                const ctx = document.getElementById('totalPaymentsChart').getContext('2d');
                                new Chart(ctx, {
                                type: 'bar',
                                data: {
                                labels: monthLabels,
                                datasets: [{
                                label: 'Monthly Total Payments',
                                data: monthlyTotals,
                                backgroundColor: 'rgba(143,21,21,1.0)',
                                }]
                                },
                                options: {
                                scales: {
                                y: {
                                beginAtZero: true,
                                ticks: {
                                callback: function (value) {
                                return 'PHP ' + value.toLocaleString('en-PH', { minimumFractionDigits: 2 });
                                }
                                }
                                }
                                },
                                plugins: {
                                legend: {
                                display: true,
                                position: 'bottom'
                                },
                                tooltip: {
                                callbacks: {
                                label: function (context) {
                                const val = context.parsed.y;
                                return 'PHP ' + val.toLocaleString('en-PH', { minimumFractionDigits: 2 });
                                }
                                }
                                }
                                }
                                }
                                });
                                },
                                error: function () {
                                console.error('Failed to load payments XML');
                                alert('Error loading payment data.');
                                }
                                });
                                });
                            </script>
                              
                            
                            <!-- Latest Payments -->
                            <div class="row gx-3 gy-3">
                                <div class="col-12 col-sm-6">
                                    <div class="container-fluid d-flex">
                                        <p class="h2 font-red-gradient mx-auto mt-5">Latest Payments</p>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table text-center align-middle">
                                            <thead style="background-color: #8e1616 !important; color: white">
                                                <tr>
                                                    <th>Renter Name</th>
                                                    <th>Payment Date</th>
                                                    <th>Payment Amount</th>
                                                </tr>
                                            </thead>
                                            <tbody style="border-top: 2px solid #8e1616">
                                                <xsl:for-each select="$data//payments/payment">
                                                    <!-- Sort payments by paymentDate descending -->
                                                    <xsl:sort select="paymentDate" data-type="text" order="descending" />
                                                    <!-- Limit to first 3 -->
                                                    <xsl:if test="position() &lt;= 3">
                                                        <tr style="border-bottom: 2px solid #8e1616">
                                                            <td><xsl:value-of select="renterId"/></td> <!-- Replace with renter name if available -->
                                                            <td><xsl:value-of select="paymentDate"/></td>
                                                            <td>
                                                                PHP <xsl:value-of select="format-number(number(amount), '#,##0.00')"/>
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </tbody>
                                              
                                        </table>
                                    </div>
                                </div>
                                
                                <div class="col-12 col-sm-6 gradient-red-bg rounded-4 p-4">
                                    <div class="container-fluid d-flex">
                                        <p class="h2 font-white mx-auto">
                                            <xsl:value-of select="count($data//tasks/task[not(status='Completed')])"/> Pending Tasks
                                        </p>
                                    </div>
                                    
                                    <xsl:for-each select="$data//tasks/task[not(status='Completed')]">
                                        <xsl:sort select="dueDate" data-type="text" order="ascending"/>
                                        <xsl:if test="position() &lt;= 4">
                                            <div class="d-flex flex-column mb-3">
                                                <div class="d-flex flex-row align-items-center">
                                                    <p class="h6 font-white mb-0 me-2">
                                                        <xsl:value-of select="title"/>
                                                    </p>
                                                    <xsl:if test="status">
                                                        <span class="badge rounded-pill ms-2 p-2">
                                                            <xsl:attribute name="class">
                                                                <xsl:text>badge rounded-pill p-2 ms-2 </xsl:text>
                                                                <xsl:choose>
                                                                    <xsl:when test="status='Overdue'">bg-warning</xsl:when>
                                                                    <xsl:when test="status='Pending'">bg-secondary</xsl:when>
                                                                    <xsl:otherwise>bg-secondary</xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="status"/>
                                                        </span>
                                                    </xsl:if>
                                                </div>
                                            </div>
                                        </xsl:if>
                                    </xsl:for-each>
                                </div>
                                  
                                  
                            </div>
                        </div>
                    </div>
                </div>
                
                
                
                <!-- Modal Add Renter -->
                <div class="modal fade" id="modalAddRenter" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
                        <div class="modal-content p-4">
                            
                            <!-- Modal Header -->
                            <div class="modal-header">
                                <p class="modal-title h2 font-red-gradient">Add Renter</p>
                            </div>
                            
                            <!-- Modal body -->
                            <div class="modal-body d-flex flex-column">
                                <p class="h5 font-red-gradient">Personal Information</p>
                                <div class="d-flex flex-row mb-3 flex-wrap">
                                    <div class="form-floating me-2 flex-fill">
                                        <input type="text" class="form-control" id="add-renter-surname" placeholder="" required="required"/>
                                            <label for="add-renter-surname">Surname *</label>
                                        </div>
                                        <div class="form-floating me-2 flex-fill">
                                            <input type="text" class="form-control" id="add-renter-first-name" placeholder="" required="required"/>
                                                <label for="add-renter-first-name">First Name *</label>
                                            </div>
                                            <div class="form-floating me-2 flex-fill">
                                                <input type="text" class="form-control" id="add-renter-middle-name" placeholder=""/>
                                                    <label for="add-renter-middle-name">Middle Name</label>
                                                </div>
                                                <div class="form-floating me-2 flex-fill">
                                                    <input type="text" class="form-control" id="add-renter-ext-name" placeholder=""/>
                                                        <label for="add-renter-ext-name">Extension Name</label>
                                                    </div>
                                                    <div class="form-floating me-2 flex-fill">
                                                        <input type="text" class="form-control" id="add-renter-contact-number" placeholder="" required="required"/>
                                                            <label for="add-renter-contact-number">Contact Number *</label>
                                                        </div>
                                                        <div class="date-input-container me-2 flex-fill">
                                                            <label for="add-renter-birthdate" class="date-label">Birthdate <span>*</span></label>
                                                            <label class="date-input-wrapper">
                                                                <input type="date" id="add-renter-birthdate" class="custom-date-input" required="required"/>
                                                                    <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px"
                                                                                                            viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                                                                            <path
                                                                                d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                                                                        </svg></span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        
                                                        <p class="h5 font-red-gradient">Valid ID Information</p>
                                                        <div class="d-flex flex-row mb-3 flex-wrap">
                                                            <div class="me-2 mb-3 flex-fill">
                                                                <select class="form-select custom-select" id="add-renter-valid-id-type" required="required" style="height: 3.5rem;">
                                                                    <option selected="selected" disabled="disabled" hidden="hidden">Valid ID Type *</option>
                                                                    <option value="national-id">National ID</option>
                                                                    <option value="sss">SSS ID</option>
                                                                    <option value="umid">UMID</option>
                                                                    <option value="philhealth">PhilHealth ID</option>
                                                                    <option value="pagibig">Pag-IBIG ID</option>
                                                                    <option value="tin">TIN ID</option>
                                                                    <option value="driver-license">Driver's License</option>
                                                                    <option value="passport">Philippine Passport</option>
                                                                    <option value="voter-id">Voter's ID / Voter's Certification</option>
                                                                    <option value="national-id">PhilSys National ID</option>
                                                                    <option value="postal-id">Postal ID</option>
                                                                    <option value="prc">PRC ID</option>
                                                                    <option value="student-id">Student ID (with current enrollment proof)</option>
                                                                    <option value="senior-id">Senior Citizen ID</option>
                                                                    <option value="pwd-id">PWD ID</option>
                                                                </select>
                                                            </div>
                                                            <div class="form-floating me-2 flex-fill">
                                                                <input type="text" class="form-control" id="add-renter-valid-id-number" placeholder="" required="required"/>
                                                                    <label for="add-renter-valid-id-number">ID Number *</label>
                                                                </div>
                                                            </div>
                                                            
                                                            <p class="h5 font-red-gradient ">Rental Information</p>
                                                            <div class="d-flex flex-row mb-3 flex-wrap">
                                                                <div class="me-2 mb-3 flex-fill">
                                                                    <select class="form-select custom-select" id="add-renter-room-number" required="required" style="height: 3.5rem;">
                                                                        <option selected="selected" disabled="disabled" hidden="hidden">Room Number *</option>
                                                                        <option value="1A">1A</option>
                                                                        <!-- TODO: FROM XML -->
                                                                    </select>
                                                                </div>
                                                                <div class="form-floating me-2 flex-fill">
                                                                    <input type="text" class="form-control" id="add-renter-contract-term" placeholder="" required="required"/>
                                                                        <label for="add-renter-contract-term">Contract Term <i>(in months)</i> *</label>
                                                                    </div>
                                                                    <div class="date-input-container me-2 flex-fill">
                                                                        <label for="add-renter-lease-start" class="date-label">Lease Start <span>*</span></label>
                                                                        <label class="date-input-wrapper">
                                                                            <input type="date" id="add-renter-lease-start" class="custom-date-input" required="required"/>
                                                                                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px"
                                                                                                                        viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                                                                                        <path
                                                                                            d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                                                                                    </svg></span>
                                                                            </label>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <p class="h5 font-red-gradient">Security</p>
                                                                    <div class="d-flex flex-row mb-3 flex-wrap">
                                                                        <div class="form-floating flex-fill me-2">
                                                                            <input type="email" class="form-control" id="add-renter-email" placeholder="name@example.com" required="required"/>
                                                                                <label for="add-renter-email">Email Address *</label>
                                                                            </div>
                                                                            <div class="form-floating position-relative me-2 flex-fill">
                                                                                <input type="password" class="form-control" id="add-renter-password" placeholder="Password" required="required"/>
                                                                                    <label for="add-renter-password">Password *</label>
                                                                                    <button type="button"
                                                                                            class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                                            onclick="togglePasswordVisibility('add-renter-password')">
                                                                                        <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                                    </button>
                                                                                </div>
                                                                                <div class="form-floating position-relative flex-fill">
                                                                                    <input type="password" class="form-control" id="add-renter-confirm-password" placeholder="Password"
                                                                                            required="required"/>
                                                                                        <label for="add-renter-confirm-password">Confirm Password *</label>
                                                                                        <button type="button"
                                                                                                class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                                                onclick="togglePasswordVisibility('add-renter-confirm-password')">
                                                                                            <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                                        </button>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                            </div>
                                                                            
                                                                            
                                                                            <!-- Modal footer -->
                                                                            <div class="modal-footer d-flex justify-content-between">
                                                                                <div id="error-box-add-renter"
                                                                                        class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6"
                                                                                        style="color:white; background-color: #a6192e;">
                                                                                    <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                                    <div>
                                                                                        <strong class="fs-5">Warning!</strong><br />
                                                                                        <span class="small" id="error-text-add-renter"></span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="ms-auto">
                                                                                    <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-add-renter">Cancel</button>
                                                                                    <button type="button" class="btn-green-fill" id="button-add-renter">Add</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- Modal Add Renter Confirmation -->
                                                                <div class="modal fade" id="modalAddRenterConfirmation" tabindex="-1">
                                                                    <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                                        <div class="modal-content p-4">
                                                                            
                                                                            <!-- Modal Header -->
                                                                            <div class="modal-header">
                                                                                <p class="modal-title h2 font-red-gradient">Add Renter Confirmation</p>
                                                                            </div>
                                                                            
                                                                            <!-- Modal body -->
                                                                            <div class="modal-body d-flex flex-sm-row flex-column">
                                                                                <div class="d-flex flex-column me-5">
                                                                                    <p class="h4 font-red-gradient">Personal Information</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Name:</p>
                                                                                        <p class="font-red"><span id="confirm-add-renter-first-name" class="font-red"></span> <span
                                                                                                id="confirm-add-renter-middle-name"></span> <span id="confirm-add-renter-surname"></span> <span
                                                                                                id="confirm-add-renter-ext-name"></span></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Contact Number:</p>
                                                                                        <p id="confirm-add-renter-contact-number" class="font-red"></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Birth Date:</p>
                                                                                        <p id="confirm-add-renter-birthdate" class="font-red"></p>
                                                                                    </div>
                                                                                    
                                                                                    <p class="h4 font-red-gradient mt-3">Valid ID Information</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Valid ID Type:</p>
                                                                                        <p id="confirm-add-renter-valid-id-type" class="font-red"></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">ID Number:</p>
                                                                                        <p id="confirm-add-renter-valid-id-number" class="font-red"></p>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                                <div class="d-flex flex-column">
                                                                                    <p class="h4 font-red-gradient mt-3">Rental Information</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Room Number:</p>
                                                                                        <p><span id="confirm-add-renter-room-number" class="font-red"></span></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Lease Start:</p>
                                                                                        <p id="confirm-add-renter-lease-start" class="font-red"></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Contract Term:</p>
                                                                                        <p id="confirm-add-renter-contract-term" class="font-red"></p>
                                                                                    </div>
                                                                                    
                                                                                    <p class="h4 font-red-gradient mt-3">Security</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Email Address:</p>
                                                                                        <p id="confirm-add-renter-email" class="font-red"></p>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                            </div>
                                                                            
                                                                            <!-- Modal footer -->
                                                                            <div class="modal-footer">
                                                                                <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal"
                                                                                        data-bs-target="#modalAddRenter">Return</button>
                                                                                <button type="button" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal"
                                                                                        data-bs-target="#modalAddRenterSuccess" id="button-confirm-add-renter">Confirm</button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                
                                                                <!-- Modal Add Renter Success -->
                                                                <div class="modal fade" id="modalAddRenterSuccess" tabindex="-1">
                                                                    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                                        <div class="modal-content p-4">
                                                                            
                                                                            <!-- Modal Header -->
                                                                            <div class="modal-header d-flex align-items-center justify-content-center">
                                                                                <p class="modal-title h2 font-green text-center">New Renter Added!</p>
                                                                            </div>
                                                                            
                                                                            <!-- Modal body -->
                                                                            <div class="modal-body d-flex align-items-center justify-content-center">
                                                                                <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456">
                                                                                    <path
                                                                                        d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z" />
                                                                                </svg>
                                                                            </div>
                                                                            
                                                                            <!-- Modal footer -->
                                                                            <div class="modal-footer d-flex align-items-center justify-content-center">
                                                                                <button type="button" class="btn-green-fill" data-bs-dismiss="modal"
                                                                                        id="button-success-add-renter">Confirm</button>
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
                                                                                <p class="modal-title h4 font-red-gradient">R25000002</p>
                                                                            </div>
                                                                            
                                                                            <!-- Modal body -->
                                                                            <div class="modal-body">
                                                                                <div class="d-flex flex-column">
                                                                                    <select class="form-select custom-select select-sort me-1 col-1" id="record-payment-renter">
                                                                                        <option selected="selected" disabled="disabled" hidden="hidden">Renter Name *</option>
                                                                                        <option value="userid">Dave Alon</option>
                                                                                    </select>
                                                                                    <p class="h4 font-red-gradient mt-3">Payment Type</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <label class="custom-checkbox-container me-2">
                                                                                            <input type="checkbox" class="custom-checkbox" id="record-payment-electric-checkbox"/>
                                                                                                Electric
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
                                                                                                        <input type="text" class="form-control" id="record-payment-payment-amount" placeholder="" required="required"/>
                                                                                                            <label for="record-payment-payment-amount">Payment
                                                                                                                Amount *</label>
                                                                                                        </div>
                                                                                                        <select class="form-select custom-select select-sort me-1 col-1 mt-3" id="record-payment-method">
                                                                                                            <option selected="selected" disabled="disabled" hidden="hidden">Payment Method
                                                                                                                    *</option>
                                                                                                            <option value="cash">Cash</option>
                                                                                                            <option value="gcash">GCash</option>
                                                                                                        </select>
                                                                                                        <select class="form-select custom-select select-sort me-1 col-1 mt-3" id="record-payment-method">
                                                                                                            <option selected="selected" disabled="disabled" hidden="hidden">Payment Amount Type
                                                                                                                    *</option>
                                                                                                            <option value="cash">Full Payment</option>
                                                                                                            <option value="gcash">Partial Payment</option>
                                                                                                        </select>
                                                                                                        <div class="form-floating me-2 flex-fill mt-3">
                                                                                                            <input type="text" class="form-control" id="record-payment-remarks" placeholder="" required="required"/>
                                                                                                                <label for="record-payment-remarks">Remarks</label>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    
                                                                                                    <!-- Modal footer -->
                                                                                                    <div class="modal-footer d-flex align-items-end">
                                                                                                        <button type="button" class="btn-red" data-bs-dismiss="modal">Cancel</button>
                                                                                                        <button type="button" class="btn-green-fill" id="button-record-payment">Record</button>
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
                                                                                                            <p class="h5 font-red-gradient me-2">Renter Name:</p>
                                                                                                            <p id="confirm-record-renter-name" class="font-red"></p>
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
                                                                                                        <button type="button" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal"
                                                                                                                data-bs-target="#modalRecordPaymentSuccess" id="button-confirm-record-payment">Confirm</button>
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