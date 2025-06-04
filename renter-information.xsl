<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
        <html lang="en">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Information &#128240; | RentaHub</title>
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
                </script>
                <body class="h-100">
                <!-- Loading Screen -->
                <div id="loading-screen">
                    <div class="spinner"></div>
                    <p>Loading, please wait...</p>
                </div>
                    <audio id="error-sound" src="audio/error.mp3" preload="auto"></audio>
                    
                    <!-- Toggle Button for sm and md screens -->
                    <button class="btn d-block d-xl-none m-3" type="button" data-bs-toggle="offcanvas" data-bs-target="#sideMenuOffcanvas" aria-controls="sideMenuOffcanvas"/>
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
                                        <a class="nav-link sidebar-nav mt-1 active " href="renter-information.xml">
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
                            <div class="d-flex mt-auto align-items-center align-self-center flex-column ">
                                <div class=" bg-white p-1 px-5 rounded-2 d-flex flex-row">
                                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8E1616"><path d="M160-200v-60h80v-304q0-84 49.5-150.5T420-798v-22q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v22q81 17 130.5 83.5T720-564v304h80v60H160Zm320-302Zm0 422q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM300-260h360v-304q0-75-52.5-127.5T480-744q-75 0-127.5 52.5T300-564v304Z"/></svg>
                                    <p class="h6 align-self-center mb-0 pb-0 fw-bold font-red-gradient ms-1">Notifications!</p>
                                </div>
                                
                                <div id="notifications-list" class="col-12 overflow-auto d-flex flex-row" style="min-width: 32vh; max-width: 32vh; min-height: 24vh; max-height: 24vh;">
                                    <div 
                                        class="alert d-flex flex-row align-items-start justify-content-between gap-3 p-3 border-0 rounded-3 col-12 notification-item bg-white mt-1">
                                        
                                        <div>
                                            <strong class="fs-5 font-red"></strong>
                                        </div>
                                        <button
                                            type="button"
                                            class="btn-red-fill d-flex align-items-center p-1 button-notif-read">
                                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3">
                                                <path d="M382-240 154-468l57-57 171 171 367-367 57 57-424 424Z"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                                
                            </div>
                                <div class="d-flex mt-auto align-items-center align-self-center flex-column">
                                    <p class="small align-self-center fw-bold mb-0 pb-0 current-date"></p>
                                    <p class="align-self-center pt-0 mt-0" style="font-size: 0.6rem">
                                        &#169; <span class="current-year"></span> RentaHub. All Rights
                                        Reserved.
                                    </p>
                                </div>
                            </div>
                            
                            <div class="main-container h-100 p-4" id="main-container">
                                
                               <script>
      $(document).ready(function() {
    // 1. Load data from localStorage
    const currentUser = JSON.parse(localStorage.getItem('currentUser'));

    // 2. Check if data exists
    if (currentUser) {
        const userId = currentUser.id;

        // 3. Update HTML
        $.ajax({
            url: 'apartment.xml', // Your XML file
            dataType: 'xml',
            success: function(xml) {
                $(xml).find('renters &gt; renter').each(function() {
                    if ($(this).find('userId').text() === userId) {
                        // Update the HTML elements with data from XML
                        const firstName = $(this).find('personalInfo &gt; name &gt; firstName').text();
                        const surname = $(this).find('personalInfo &gt; name &gt; surname').text();
                        const middleName = $(this).find('personalInfo &gt; name &gt; middleName').text();
                        const extension = $(this).find('personalInfo &gt; name &gt; extension').text();
                        const unitId = $(this).find('rentalInfo &gt; unitId').text();
                        const leaseStart = $(this).find('rentalInfo &gt; leaseStart').text();
                        const contact = $(this).find('personalInfo &gt; contact').text();
                        const birthDate = $(this).find('personalInfo &gt; birthDate').text();
                        const validIdType = $(this).find('personalInfo &gt; validId &gt; validIdType').text();
                        const validIdNumber = $(this).find('personalInfo &gt; validId &gt; validIdNumber').text();

                        // Get username (email) from usersMap
                        const username = usersMap[userId]?.email || currentUser.email || 'Not set';

                        $('.main-container').html(`
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <p class="h2 font-red-gradient mb-0">${firstName} ${surname}</p>
                            </div>
                            
                            <div class="horizontal mt-1 mb-2"></div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <p class="h5 font-red-gradient mb-0">Room ${unitId} | Lease Start: ${leaseStart}</p>
                                <button type="button" class="ms-auto btn-red d-flex align-items-center px-3 py-1" data-bs-toggle="modal" data-bs-target="#modalModifyRenterRenterRole">
                                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                                        <path d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Zm640-584-56-56 56 56Zm-141 85-28-29 57 57-29-28Z"/>
                                    </svg>
                                    Edit
                                </button>
                            </div>
                            
                            <div class="d-flex flex-column flex-md-row gap-3 mb-3">
                                <!-- Personal Information -->
                                <div class="flex-fill gradient-red-bg p-4 rounded-3">
                                    <p class="h4 font-white mb-3">Personal Information</p>
                                    <div class="d-flex flex-row mb-2">
                                        <p class="h5 font-white me-2 mb-0">Name: </p>
                                        <p class="font-white mb-0">
                                            ${firstName} ${middleName} ${surname} ${extension}
                                        </p>
                                    </div>
                                    <div class="d-flex flex-row mb-2">
                                        <p class="h5 font-white me-2 mb-0">Contact Number: </p>
                                        <p class="font-white mb-0">${contact}</p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-white me-2 mb-0">Birth Date: </p>
                                        <p class="font-white mb-0">${birthDate}</p>
                                    </div>
                                </div>
                                
                                <!-- Valid ID Information -->
                                <div class="flex-fill gradient-red-bg p-4 rounded-3">
                                    <p class="h4 font-white mb-3">Valid ID Information</p>
                                    <div class="d-flex flex-row mb-2">
                                        <p class="h5 font-white me-2 mb-0">Valid ID Type: </p>
                                        <p class="font-white mb-0">${validIdType}</p>
                                    </div>
                                    <div class="d-flex flex-row">
                                        <p class="h5 font-white me-2 mb-0">ID Number: </p>
                                        <p class="font-white mb-0">${validIdNumber}</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Security Information -->
                            <div class="gradient-red-bg p-4 rounded-3 mb-3">
                                <p class="h4 font-white mb-3">Security</p>
                                <div class="d-flex flex-row justify-content-start align-items-center gap-5 flex-wrap">
                                    <div class="d-flex align-items-center me-5">
                                        <p class="h5 font-white mb-0 me-2">Email:</p>
                                        <p id="view-renter-username" class="font-white mb-0">${username}</p>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <p class="h5 font-white mb-0 me-2">Password:</p>
                                        <p class="font-white mb-0 me-2 fst-italic">Accessible in Modify</p>
                                    </div>
                                </div>
                            </div>
                        `);
                    }
                });
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('Error loading XML:', textStatus, errorThrown);
                $('.main-container').html('<p>Failed to load renter information.</p>');
            }
        });
    } else {
        // Handle the case where there's no user in localStorage
        $('.main-container').html('<p>No user logged in.</p>');
    }
});

                               </script>

                            </div>
                            
                            
                            <!-- Modal Modify Renter Information -->
                            <div class="modal fade" id="modalModifyRenterRenterRole" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
                                    <div class="modal-content p-4">
                                        
                                        <!-- Modal Header -->
                                        <div class="modal-header">
                                            <p class="modal-title h2 font-red-gradient">Modify Renter Information</p>
                                        </div>
                                        
                                        <!-- Modal body -->
                                        <div class="modal-body d-flex flex-column">
                                            <p class="h5 font-red-gradient">Personal Information</p>
                                            <div class="d-flex flex-row mb-3 flex-wrap">
                                                <div class="form-floating me-2 flex-fill">
                                                    <input type="text" class="form-control" id="modify-renter-surname-renter-role" placeholder="" required="required"/>
                                                        <label for="modify-renter-surname-renter-role">Surname *</label>
                                                    </div>
                                                    <div class="form-floating me-2 flex-fill">
                                                        <input type="text" class="form-control" id="modify-renter-first-name-renter-role" placeholder="" required="required"/>
                                                            <label for="modify-renter-first-name-renter-role">First Name *</label>
                                                        </div>
                                                        <div class="form-floating me-2 flex-fill">
                                                            <input type="text" class="form-control" id="modify-renter-middle-name-renter-role" placeholder=""/>
                                                                <label for="modify-renter-middle-name-renter-role">Middle Name</label>
                                                            </div>
                                                            <div class="form-floating me-2 flex-fill">
                                                                <input type="text" class="form-control" id="modify-renter-ext-name-renter-role" placeholder=""/>
                                                                    <label for="modify-renter-ext-name-renter-role">Extension Name</label>
                                                                </div>
                                                                <div class="form-floating me-2 flex-fill">
                                                                    <input type="text" class="form-control" id="modify-renter-contact-number-renter-role" placeholder="" required="required"/>
                                                                        <label for="modify-renter-contact-number-renter-role">Contact Number *</label>
                                                                    </div>
                                                                    <div class="date-input-container me-2 flex-fill">
                                                                        <label for="modify-renter-birthdate-renter-role" class="date-label">Birthdate <span>*</span></label>
                                                                        <label class="date-input-wrapper">
                                                                            <input type="date" id="modify-renter-birthdate-renter-role" class="custom-date-input" required="required" />
                                                                                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
                                                                            </label>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <p class="h5 font-red-gradient">Valid ID Information</p>
                                                                    <div class="d-flex flex-row mb-3 flex-wrap">
                                                                        <div class="me-2 mb-3 flex-fill">
                                                                            <select class="form-select custom-select" id="modify-renter-valid-id-type-renter-role" required="required" style="height: 3.5rem;">
                                                                                <option selected="selected" disabled="disabled " hidden="hidden">Valid ID Type *</option> 
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
                                                                            <input type="text" class="form-control" id="modify-renter-valid-id-number-renter-role" placeholder="" required="required"/>
                                                                                <label for="modify-renter-valid-id-number-renter-role">ID Number *</label>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <p class="h5 font-red-gradient "> Security Information</p>
                                                                        <div class="d-flex flex-row mb-3 flex-wrap">
                                                                            <div class="me-2 mb-3 flex-fill">
                                                                                <div class="form-floating me-2 flex-fill">
                                                                                    <input type="text" class="form-control" id="modify-renter-username-renter-role" placeholder="" required="required"/>
                                                                                        <label for="modify-renter-username-renter-role">Username</label>
                                                                                    </div>
                                                                                    <div class="position-relative flex-fill">
                                                                                        <div class="form-floating">
                                                                                        <input type="password" class="form-control" id="modify-renter-password-renter-role" placeholder="Password"/>
                                                                                        <label for="modify-renter-password-renter-role">Password</label>
                                                                                        <button class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent"
                                                                                                onclick="togglePasswordVisibility('modify-renter-password-renter-role')" id="password">
                                                                                            <i id="eyeIcon" class="bi bi-eye-slash"></i>
                                                                                        </button>
                                                                                        </div>
                                                                                        </div>    
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            
                                                                            <!-- Modal footer -->
                                                                            <div class="modal-footer d-flex justify-content-between">
                                                                                <div id="error-box-modify-renter-renter-role" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6" style="color:white; background-color: #a6192e;">
                                                                                    <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                                                                                    <div>
                                                                                        <strong class="fs-5">Warning!</strong><br/>
                                                                                        <span class="small" id="error-text-modify-renter-renter-role"></span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="ms-auto">
                                                                                    <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-modify-renter-renter-role">Cancel</button>
                                                                                    <button type="button" class="btn-green-fill" id="button-modify-renter-renter-role">Update</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                        
                            <script>
                            $(document).ready(function() {
                            const currentUserStr = localStorage.getItem('currentUser');
                            
                            if (!currentUserStr) {
                            return;
                            }
                            
                            const currentUser = JSON.parse(currentUserStr);
                            const currentUserId = currentUser.id;
                            $("#hidden-modify-renter-user-id-renter-role").val(currentUserId);

                            
                            $.ajax({
                            url: 'apartment.xml',
                            dataType: 'xml',
                            success: function(xml) {
                            let renterId = null;
                            let renterNode = null;
                            
                            $(xml).find('renters &gt; renter').each(function() {
                            if ($(this).find('userId').text().trim() === currentUserId) {
                            renterId = $(this).attr('id').trim();
                            renterNode = $(this);
                              $("#hidden-modify-renter-renter-id-renter-role").val(renterId);

                            return false; 
                            }
                            });
                            
                            if (!renterId || !renterNode) {
                            return;
                            }
                            
                            const surname = renterNode.find('personalInfo &gt; name &gt; surname').text().trim();
                            const firstName = renterNode.find('personalInfo &gt; name &gt; firstName').text().trim();
                            const middleName = renterNode.find('personalInfo &gt; name &gt; middleName').text().trim();
                            const extension = renterNode.find('personalInfo &gt; name &gt; extension').text().trim();
                            const contact = renterNode.find('personalInfo &gt; contact').text().trim();
                            const birthDate = renterNode.find('personalInfo &gt; birthDate').text().trim();
                            const validIdType = renterNode.find('personalInfo &gt; validId &gt; validIdType').text().trim();
                            const validIdNumber = renterNode.find('personalInfo &gt; validId &gt; validIdNumber').text().trim();
                            const roomNumber = renterNode.find('rentalInfo &gt; unitId').text().trim();
                            $("#hidden-modify-renter-room-number-renter-role").val(roomNumber);
                            
                            const contractTerm = renterNode.find('rentalInfo &gt; contractTermInMonths').text().trim();
                            $("#hidden-modify-renter-contract-term-renter-role").val(contractTerm);
                            
                            const leaseStart = renterNode.find('rentalInfo &gt; leaseStart').text().trim();
                            $("#hidden-modify-renter-lease-start-renter-role").val(leaseStart);
                            
                            let username = '';
                            if (typeof usersMap !== 'undefined' &amp;&amp; usersMap[currentUserId]) {
                            username = usersMap[currentUserId].email;
                            } else if (currentUser.email) {
                            username = currentUser.email;
                            }
                            
                            let password = '';
                            if (typeof usersMap !== 'undefined' &amp;&amp; usersMap[currentUserId]) {
                            password = usersMap[currentUserId].password || '';
                            } else {
                            $(xml).find('users &gt; user').each(function() {
                            if ($(this).attr('id').trim() === currentUserId) {
                            password = $(this).find('password').text().trim();
                            return false;
                            }
                            });
                            }
                            
                            $('#modify-renter-surname-renter-role').val(surname);
                            $('#modify-renter-first-name-renter-role').val(firstName);
                            $('#modify-renter-middle-name-renter-role').val(middleName);
                            $('#modify-renter-ext-name-renter-role').val(extension);
                            $('#modify-renter-contact-number-renter-role').val(contact);
                            $('#modify-renter-birthdate-renter-role').val(birthDate);
                            $('#modify-renter-valid-id-type-renter-role').val(validIdType);
                            $('#modify-renter-valid-id-number-renter-role').val(validIdNumber);
                            $('#modify-renter-username-renter-role').val(username);
                            $('#modify-renter-password-renter-role').val(password);
                            }
                            });
                            <!-- $('#modalModifyRenterRenterRole').modal('show'); -->
                            });
                            </script>
                        
                                                                <!-- Modal Modify Renter Confirmation -->
                                                                <div class="modal fade" id="modalModifyRenterRenterRoleConfirmation" tabindex="-1">
                                                                    <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
                                                                        <div class="modal-content p-4">
                                                                            
                                                                            <!-- Modal Header -->
                                                                            <div class="modal-header">
                                                                                <p class="modal-title h2 font-red-gradient">Modify Renter Confirmation</p>
                                                                            </div>
                                                                            
                                                                            <!-- Modal body -->
                                                                            <div class="modal-body d-flex flex-sm-row flex-column">
                                                                                <div class="d-flex flex-column me-5">
                                                                                    <p class="h4 font-red-gradient">Personal Information</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Name:</p>
                                                                                        <p class="font-red"><span id="confirm-modify-renter-first-name-renter-role" class="font-red"></span>&#160;<span id="confirm-modify-renter-middle-name-renter-role"></span>&#160;<span id="confirm-modify-renter-surname-renter-role"></span>&#160;<span id="confirm-modify-renter-ext-name-renter-role"></span></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Contact Number:</p>
                                                                                        <p id="confirm-modify-renter-contact-number-renter-role" class="font-red"></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Birth Date:</p>
                                                                                        <p id="confirm-modify-renter-birthdate-renter-role" class="font-red"></p>
                                                                                    </div>
                                                                                    
                                                                                    <p class="h4 font-red-gradient mt-3">Valid ID Information</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Valid ID Type:</p>
                                                                                        <p id="confirm-modify-renter-valid-id-type-renter-role" class="font-red"></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">ID Number:</p>
                                                                                        <p id="confirm-modify-renter-valid-id-number-renter-role" class="font-red"></p>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                                <div class="d-flex flex-column">
                                                                                    <p class="h4 font-red-gradient mt-3">Security</p>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Username:</p>
                                                                                        <p><span id="confirm-modify-renter-username-renter-role" class="font-red"></span></p>
                                                                                    </div>
                                                                                    <div class="d-flex flex-row">
                                                                                        <p class="h5 font-red-gradient me-2">Password:</p>
                                                                                        <p id="confirm-modify-renter-password-renter-role" class="font-red"></p>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        <!-- </div> -->
                                                                        
                                                                             <!-- Modal footer -->
                                                                            <div class="modal-footer">
                                                                                <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalModifyRenterRenterRole">Return</button>
                                                                                <form id="hidden-modify-renter-form-renter-role" method="post" action="functions/modify-renter-renter-role.php">
                                                                                    <input type="hidden" name="surname" id="hidden-modify-renter-surname-renter-role"/>
                                                                                    <input type="hidden" name="firstName" id="hidden-modify-renter-first-name-renter-role"/>
                                                                                    <input type="hidden" name="middleName" id="hidden-modify-renter-middle-name-renter-role"/>
                                                                                    <input type="hidden" name="extName" id="hidden-modify-renter-ext-name-renter-role"/>
                                                                                    <input type="hidden" name="contact" id="hidden-modify-renter-contact-number-renter-role"/>
                                                                                    <input type="hidden" name="birthdate" id="hidden-modify-renter-birthdate-renter-role"/>
                                                                                    <input type="hidden" name="idType" id="hidden-modify-renter-valid-id-type-renter-role"/>
                                                                                    <input type="hidden" name="idNumber" id="hidden-modify-renter-valid-id-number-renter-role"/>
                                                                                    <input type="hidden" name="username" id="hidden-modify-renter-username-renter-role"/>
                                                                                    <input type="hidden" name="password" id="hidden-modify-renter-password-renter-role"/>
                                                                                    <input type="hidden" name="renterId" id="hidden-modify-renter-renter-id-renter-role"/>
                                                                                    <input type="hidden" name="userId" id="hidden-modify-renter-user-id-renter-role"/>
                                                                                    <input type="hidden" id="hidden-modify-renter-room-number-renter-role" name="roomNumber"/>
                                                                                    <input type="hidden" id="hidden-modify-renter-contract-term-renter-role" name="contractTerm"/>
                                                                                    <input type="hidden" id="hidden-modify-renter-lease-start-renter-role" name="leaseStart"/>
                                                                                    <!-- Add more hidden fields if you add more data fields in your modal -->
                                                                                <button type="submit" class="btn-green-fill" id="button-confirm-modify-renter-renter-role">Confirm</button>
                                                                                    
                                                                                </form>
                                                                                
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            
                                                            <!-- Modal Modify Renter Success -->
                                                            <div class="modal fade" id="modalModifyRenterSuccess" tabindex="-1">
                                                                <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
                                                                    <div class="modal-content p-4">
                                                                        
                                                                        <!-- Modal Header -->
                                                                        <div class="modal-header d-flex align-items-center justify-content-center">
                                                                            <p class="modal-title h2 font-green text-center">Modify Renter Success!</p>
                                                                        </div>
                                                                        
                                                                        <!-- Modal body -->
                                                                        <div class="modal-body d-flex align-items-center justify-content-center">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" height="48px" viewBox="0 -960 960 960" width="48px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
                                                                        </div>
                                                                        
                                                                        <!-- Modal footer -->
                                                                        <div class="modal-footer d-flex align-items-center justify-content-center">
                                                                            <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-modify-renter">Confirm</button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                    </div>
                                                            
                                                            
                                                        </body>
                                                    </html>
    </xsl:template>
</xsl:stylesheet>