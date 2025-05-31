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
                <!-- Latest compiled and minified CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
                <!-- Latest compiled JavaScript -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
                        integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
                        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
                <script src="script.js"></script>
                <!-- FONTS -->
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
                    <link href="https://fonts.googleapis.com/css2?family=Varela+Round&amp;display=swap" rel="stylesheet" />
                        <link rel="stylesheet" type="text/css" href="styles.css" />
                        <!--CHARTS-->
                        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
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

                        $('#usernameOnRenterDashboard').text(email);
                        $('#userRoleOnRenterDashboard').text(role);
                                    
                // User info available for use
                console.log('Logged in user:', email, 'Role:', role);
                
                // You can assign to variables or update UI as needed
                window.loggedInUsername = email;
                window.loggedInUserRole = role;
                }
                
                // Call check on page load
                document.addEventListener('DOMContentLoaded', checkUserAccess);
                
                
                    </script>
                    <body class="h-100">
                <!-- Loading Screen -->
                <div id="loading-screen">
                    <div class="spinner"></div>
                    <p>Loading, please wait...</p>
                </div>
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
                                            <a class="nav-link sidebar-nav mt-1 active" href="renter-dashboard.xml">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                                                     fill="#FFFFFF">
                                                    <path
                                                        d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z" />
                                                </svg>
                                                Dashboard
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link sidebar-nav mt-1" href="renter-information.xml">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px" 
                                                     fill="#FFFFFF">
                                                    <path 
                                                        d="M480-120q-75 0-140.5-28.5T225-225q-49-49-77.5-114.5T120-480q0-75 28.5-140.5T225-735q49-49 114.5-77.5T480-840q75 0 140.5 28.5T735-735q49 49 77.5 114.5T840-480q0 75-28.5 140.5T735-225q-49 49-114.5 77.5T480-120Zm-40-200h80v-280h-80v280Zm0-360h80v-80h-80v80Z"/>
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
                                        <p class="small align-self-center fw-bold mb-0 pb-0 current-date">
                                        </p>
                                        <p class="align-self-center pt-0 mt-0" style="font-size: 0.6rem">
                                            &#169; <span class="current-year"></span> RentaHub. All Rights Reserved.
                                        </p>
                                    </div>
                                </div>
                                
                                <!-- MAIN CONTENT -->
                                <div class="main-container h-100 p-4" id="main-container">
                                    <div class="d-flex flex-column justify-content-between align-items-start">
                                        <p class="h4 font-red-gradient"><span id="usernameOnRenterDashboard" class="h3 font-red-gradient"></span></p>
                                        <p class="h6 font-red fst-italic"><span id="userRoleOnRenterDashboard" class="h5 font-red"></span></p>
                                    </div>
                                    
                                    <div class="horizontal mt-1 mb-2"></div>
                                    <!-- METRICS -->
                                    <div class="row gx-3 gy-3">
                                        <div class="col-12 col-sm-6 col-lg-4">
                                            <div class="gradient-red-bg d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h5 font-white my-0">Total Current Bills</p>
                                                <p class="h3 font-white ms-3 my-0">PHP 15,283.17 </p>
                                            </div>
                                        </div>

                                        
                                        <div class="col-12 col-sm-6 col-lg-4">
                                            <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h3 font-red my-0" id="next-due-days">Next Due in -- Days</p>
                                                <p class="h3 font-red my-0" id="next-due-date">--</p>
                                            </div>
                                        </div>
                                        
                                        <div class="col-12 col-sm-6 col-lg-4">
                                           <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-red my-0">Total Bills Paid</p>
                                                <p class="h3 font-red my-0" id="renter-role-total-bills-paid">0</p>
                                            </div>

                                        </div>
                                        
                                        <div class="col-12 col-sm-6 col-lg-4">
                                            <div class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h6 font-red my-0">Collection Rate</p>
                                                <p class="h3 font-red my-0" id="collection-rate">0.00%</p>
                                            </div>

                                        </div>
                                        
                                        <div class="col-12 col-sm-6 col-lg-4">
                                            <div class="gradient-red-bg d-flex flex-row align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                                                <p class="h5 font-white my-0">Total Payments</p>
                                                <p class="h3 font-white ms-3 my-0" id="renter-role-total-payments">PHP 0.00</p>
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
   function aggregateMonthlyPayments(payments, currentUserId, renterDataMap) {
  // Find renterId by userId
  let renterId = null;
  for (const rId in renterDataMap) {
    if (renterDataMap.hasOwnProperty(rId)) {
      if (renterDataMap[rId].userId === currentUserId) {
        renterId = rId;
        break;
      }
    }
  }

  if (!renterId) {
    // Return an array of zeros if the renterId isn't found
    return new Array(12).fill(0);
  }

  const monthlyTotals = new Array(12).fill(0);

  for (const id in payments) {
    if (payments.hasOwnProperty(id)) {
      const payment = payments[id];

      // Skip if essential payment data is missing
      if (!payment.paymentDate || !payment.amount) continue;

      // Skip if payment is not for the target renter
      if (payment.renterId !== renterId) continue;

      const date = new Date(payment.paymentDate);
      // Skip if the payment date is invalid
      if (isNaN(date)) continue;

      const monthIndex = date.getMonth();
      // Clean and parse the amount, defaulting to 0 if invalid
      const amount = parseFloat(payment.amount.toString().replace(/[^0-9.-]+/g, '')) || 0;

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
                                $(xml).find('payments &gt; payment').each(function () {
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
                                
                                const currentUserStr = localStorage.getItem('currentUser');
                                let currentUser;
                                try {
                                currentUser = JSON.parse(currentUserStr);
                                } catch (e) {
                                console.error('Failed to parse currentUser from localStorage', e);
                                signOut();
                                return;
                                }

                                
                                const monthlyTotals = aggregateMonthlyPayments(paymentsMap, currentUser.id, renterDataMap);
                                
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
                                <div class="col-6 mx-auto">
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
                                                            <td><xsl:value-of select="paymentType"/></td> <!-- Replace with renter name if available -->
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
                            </div>
                                </div>
                            </div>
                                    
                                </body>
                            </html>

    </xsl:template>
</xsl:stylesheet>