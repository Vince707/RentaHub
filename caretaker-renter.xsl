<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="data" select="document('apartment.xml')" />
    <xsl:template match="/">
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Renter &#127969; | RentaHub</title>
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
  $(document).ready(function () {
    $('#renter-information-table').DataTable({
      layout: {
        bottomStart: {
          buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
        }
      }
    });
    $('#renter-archive-information-table').DataTable({
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
</script>

<body class="h-100">  
  <audio id="error-sound" src="audio/error.mp3" preload="auto"></audio>
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
            <a class="nav-link sidebar-nav mt-1" href="caretaker-dashboard.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z" />
              </svg>
              Dashboard
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="caretaker-tasks.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h168q13-36 43.5-58t68.5-22q38 0 68.5 22t43.5 58h168q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm80-80h280v-80H280v80Zm0-160h400v-80H280v80Zm0-160h400v-80H280v80Zm200-190q13 0 21.5-8.5T510-820q0-13-8.5-21.5T480-850q-13 0-21.5 8.5T450-820q0 13 8.5 21.5T480-790ZM200-200v-560 560Z" />
              </svg>
              Tasks
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1 active" href="caretaker-renter.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M40-160v-112q0-34 17.5-62.5T104-378q62-31 126-46.5T360-440q66 0 130 15.5T616-378q29 15 46.5 43.5T680-272v112H40Zm720 0v-120q0-44-24.5-84.5T666-434q51 6 96 20.5t84 35.5q36 20 55 44.5t19 53.5v120H760ZM360-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47Zm400-160q0 66-47 113t-113 47q-11 0-28-2.5t-28-5.5q27-32 41.5-71t14.5-81q0-42-14.5-81T544-792q14-5 28-6.5t28-1.5q66 0 113 47t47 113ZM120-240h480v-32q0-11-5.5-20T580-306q-54-27-109-40.5T360-360q-56 0-111 13.5T140-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T440-640q0-33-23.5-56.5T360-720q-33 0-56.5 23.5T280-640q0 33 23.5 56.5T360-560Zm0 320Zm0-400Z" />
              </svg>
              Renter Information
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="caretaker-room.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M120-120v-80h80v-640h400v40h160v600h80v80H680v-600h-80v600H120Zm160-640v560-560Zm160 320q17 0 28.5-11.5T480-480q0-17-11.5-28.5T440-520q-17 0-28.5 11.5T400-480q0 17 11.5 28.5T440-440ZM280-200h240v-560H280v560Z" />
              </svg>
              Room Information
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="caretaker-billings.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M120-80v-800l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v800l-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60-60-60-60 60Zm120-200h480v-80H240v80Zm0-160h480v-80H240v80Zm0-160h480v-80H240v80Zm-40 404h560v-568H200v568Zm0-568v568-568Z" />
              </svg>
              Billings
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="caretaker-payments.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M560-440q-50 0-85-35t-35-85q0-50 35-85t85-35q50 0 85 35t35 85q0 50-35 85t-85 35ZM280-320q-33 0-56.5-23.5T200-400v-320q0-33 23.5-56.5T280-800h560q33 0 56.5 23.5T920-720v320q0 33-23.5 56.5T840-320H280Zm80-80h400q0-33 23.5-56.5T840-480v-160q-33 0-56.5-23.5T760-720H360q0 33-23.5 56.5T280-640v160q33 0 56.5 23.5T360-400Zm440 240H120q-33 0-56.5-23.5T40-240v-440h80v440h680v80ZM280-400v-320 320Z" />
              </svg>
              Payments
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="caretaker-help.html">
              <svg xmlns="http://www.w3.org/2000/svg" class="me-1" height="24px" viewBox="0 -960 960 960" width="24px"
                fill="#FFFFFF">
                <path
                  d="M478-240q21 0 35.5-14.5T528-290q0-21-14.5-35.5T478-340q-21 0-35.5 14.5T428-290q0 21 14.5 35.5T478-240Zm-36-154h74q0-33 7.5-52t42.5-52q26-26 41-49.5t15-56.5q0-56-41-86t-97-30q-57 0-92.5 30T342-618l66 26q5-18 22.5-39t53.5-21q32 0 48 17.5t16 38.5q0 20-12 37.5T506-526q-44 39-54 59t-10 73Zm38 314q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z" />
              </svg>
              Help
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link sidebar-nav mt-1" href="logout.html">
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
          <p class="h2 font-red-gradient">Renter Information</p>
          <div class="d-flex flex-row align-items-center">
            <button type="button" class="btn-red d-flex align-items-center px-3 py-1" id="renter-button-archives" data-bs-toggle="modal" data-bs-target="#modalArchiveRenter">
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8E1616"><path d="M200-80q-33 0-56.5-23.5T120-160v-451q-18-11-29-28.5T80-680v-120q0-33 23.5-56.5T160-880h640q33 0 56.5 23.5T880-800v120q0 23-11 40.5T840-611v451q0 33-23.5 56.5T760-80H200Zm0-520v440h560v-440H200Zm-40-80h640v-120H160v120Zm200 280h240v-80H360v80Zm120 20Z"/></svg>
              Archives
            </button>
            <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1" id="renter-button-modify-renter" data-bs-toggle="modal" data-bs-target="#modalAddRenter">
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8E1616"><path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z"/></svg>
              Add Renter
            </button>
          </div>
        </div>
        <div class="horizontal mt-1 mb-2"></div>

        <!-- TABLE -->
        <table class="custom-table" id="renter-information-table">
            <thead>
                <tr>
                <th>Room No.</th>
                <th>Renter Name</th>
                <th>Contact Number</th>
                <th>Lease Start</th>
                <th class="text-center">Status</th>
                <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$data/apartmentManagement/renters/renter">
                <xsl:if test="status != 'Archived'">
                    <tr>
                    <td><xsl:value-of select="rentalInfo/unitId"/></td>
                    <td>
                        <xsl:value-of select="personalInfo/name/firstName"/>&#160;
                        <xsl:value-of select="personalInfo/name/middleName"/>&#160;
                        <xsl:value-of select="personalInfo/name/surname"/>&#160;
                        <xsl:value-of select="personalInfo/name/extension"/>
                    </td>
                    <td><xsl:value-of select="personalInfo/contact"/></td>
                    <td><xsl:value-of select="rentalInfo/leaseStart"/></td>
                    <td>
                        <div class="d-flex justify-content-center align-items-center">
                        <span class="badge rounded-pill bg-success" id="status">
                            <xsl:value-of select="status"/>
                        </span>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex flex-row justify-content-center align-items-center align-self-center">

                        <!-- Extract renter ID -->
                        <xsl:variable name="renterId" select="@id"/>
                        <xsl:variable name="userId" select="userId"/>

                        <!-- VIEW button -->
                        <button type="button" class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-table-view-renter" data-bs-toggle="modal" data-bs-target="#modalViewRenter">
                           <xsl:attribute name="data-renter-id">
                            <xsl:value-of select="$renterId"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-user-id">
                            <xsl:value-of select="$userId"/>
                            </xsl:attribute>
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                            <path d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z"/>
                            </svg>
                        </button>

                        <!-- EDIT button -->
                        <button
                            type="button"
                            class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-table-modify-renter"
                            data-bs-toggle="modal"
                            data-bs-target="#modalModifyRenter">
                            <xsl:attribute name="data-renter-id">
                            <xsl:value-of select="$renterId"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-user-id">
                            <xsl:value-of select="$userId"/>
                            </xsl:attribute>
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                            <path d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Zm640-584-56-56 56 56Zm-141 85-28-29 57 57-29-28Z"/>
                            </svg>
                        </button>

                        <!-- DELETE button -->
                        <button
                            type="button"
                            class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-table-remove-renter"
                            data-bs-toggle="modal"
                            data-bs-target="#modalRemoveRenter">
                            <xsl:attribute name="data-renter-id">
                            <xsl:value-of select="$renterId"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-user-id">
                            <xsl:value-of select="$userId"/>
                            </xsl:attribute>
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF">
                            <path d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h280v80H200Zm440-160-55-58 102-102H360v-80h327L585-622l55-58 200 200-200 200Z"/>
                            </svg>
                        </button>

                        </div>
                    </td>
                    </tr>
                </xsl:if>
                </xsl:for-each>
            </tbody>
        </table>

        
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
                  <input type="date" id="add-renter-birthdate" class="custom-date-input" required="required" />
                  <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
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
            <option selected="selected" disabled="disabled" hidden="hidden" value="">Room Number *</option>

            <xsl:for-each select="$data/apartmentManagement/rooms/room[roomNo != '']">
                <xsl:variable name="roomNo" select="roomNo"/>
                
                <!-- Only display this room if it is NOT in use by a non-Archived renter -->
                <xsl:if test="not(/apartmentManagement/renters/renter[status != 'Archived' and rentalInfo/unitId = $roomNo])">
                    <option value="{roomNo}">
                        <xsl:value-of select="roomNo"/>
                    </option>
                </xsl:if>
            </xsl:for-each>
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
                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
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
              <button type="button" class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent" onclick="togglePasswordVisibility('add-renter-password')">
                <i id="eyeIcon" class="bi bi-eye-slash"></i>
              </button>
            </div>
            <div class="form-floating position-relative flex-fill">
              <input type="password" class="form-control" id="add-renter-confirm-password" placeholder="Password" required="required"/>
              <label for="add-renter-confirm-password">Confirm Password *</label>
              <button type="button" class="btn btn-sm position-absolute end-0 top-50 translate-middle-y me-3 border-0 bg-transparent" onclick="togglePasswordVisibility('add-renter-confirm-password')">
                <i id="eyeIcon" class="bi bi-eye-slash"></i>
              </button>
            </div>
          </div>
          
        </div>
        

        <!-- Modal footer -->
        <div class="modal-footer d-flex justify-content-between">
          <div id="error-box-add-renter" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6" style="color:white; background-color: #a6192e;">
            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
            <div>
              <strong class="fs-5">Warning!</strong><br/>
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
              <p class="font-red"><span id="confirm-add-renter-first-name" class="font-red"></span>&#160;<span id="confirm-add-renter-middle-name"></span>&#160;<span id="confirm-add-renter-surname"></span>&#160;<span id="confirm-add-renter-ext-name"></span></p>
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
          <button type="button" class="btn-red me-3" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalAddRenter">Return</button>
          <form id="add-renter" method="POST" action="functions/add-renter.php">
            <input type="hidden" id="hidden-add-renter-first-name" name="first_name"/>
            <input type="hidden" id="hidden-add-renter-middle-name" name="middle_name"/>
            <input type="hidden" id="hidden-add-renter-surname" name="surname"/>
            <input type="hidden" id="hidden-add-renter-ext-name" name="ext_name"/>
            <input type="hidden" id="hidden-add-renter-contact-number" name="contact_number"/>
            <input type="hidden" id="hidden-add-renter-birthdate" name="birthdate"/>
            <input type="hidden" id="hidden-add-renter-valid-id-type" name="valid_id_type"/>
            <input type="hidden" id="hidden-add-renter-valid-id-number" name="valid_id_number"/>
            <input type="hidden" id="hidden-add-renter-room-number" name="room_number"/>
            <input type="hidden" id="hidden-add-renter-contract-term" name="contract_term"/>
            <input type="hidden" id="hidden-add-renter-lease-start" name="lease_start"/>
            <input type="hidden" id="hidden-add-renter-email" name="email"/>
            <input type="hidden" id="hidden-add-renter-password" name="password"/>
            <button type="submit" class="btn-green-fill" data-bs-dismiss="modal" data-bs-toggle="modal"
                data-bs-target="#modalAddRenterSuccess" id="button-confirm-add-renter">Confirm</button>
          </form>
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
          <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
        </div>

        <!-- Modal footer -->
        <div class="modal-footer d-flex align-items-center justify-content-center">
          <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-add-renter">Confirm</button>
        </div>
      </div>
    </div>
  </div>


  <!-- Modal Modify Renter -->
  <div class="modal fade" id="modalModifyRenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header">
          <p class="modal-title h2 font-red-gradient">Modify Renter</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <p class="h5 font-red-gradient">Personal Information</p>
            <div class="d-flex flex-row mb-3 flex-wrap">
              <div class="form-floating me-2 flex-fill">
                <input type="text" class="form-control" id="modify-renter-surname" placeholder="" required="required"/>
                <label for="modify-renter-surname">Surname *</label>
              </div>
              <div class="form-floating me-2 flex-fill">
                <input type="text" class="form-control" id="modify-renter-first-name" placeholder="" required="required"/>
                <label for="modify-renter-first-name">First Name *</label>
              </div>
              <div class="form-floating me-2 flex-fill">
                <input type="text" class="form-control" id="modify-renter-middle-name" placeholder=""/>
                <label for="modify-renter-middle-name">Middle Name</label>
              </div>
              <div class="form-floating me-2 flex-fill">
                <input type="text" class="form-control" id="modify-renter-ext-name" placeholder=""/>
                <label for="modify-renter-ext-name">Extension Name</label>
              </div>
              <div class="form-floating me-2 flex-fill">
                <input type="text" class="form-control" id="modify-renter-contact-number" placeholder="" required="required"/>
                <label for="modify-renter-contact-number">Contact Number *</label>
              </div>
              <div class="date-input-container me-2 flex-fill">
                <label for="modify-renter-birthdate" class="date-label">Birthdate <span>*</span></label>
                <label class="date-input-wrapper">
                  <input type="date" id="modify-renter-birthdate" class="custom-date-input" required="required" />
                  <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
                </label>
              </div>
          </div>

          <p class="h5 font-red-gradient">Valid ID Information</p>
          <div class="d-flex flex-row mb-3 flex-wrap">
            <div class="me-2 mb-3 flex-fill">
              <select class="form-select custom-select" id="modify-renter-valid-id-type" required="required" style="height: 3.5rem;">
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
              <input type="text" class="form-control" id="modify-renter-valid-id-number" placeholder="" required="required"/>
              <label for="modify-renter-valid-id-number">ID Number *</label>
            </div>
          </div>

          <p class="h5 font-red-gradient ">Rental Information</p>
          <div class="d-flex flex-row mb-3 flex-wrap">
           <div class="me-2 mb-3 flex-fill">
            <select class="form-select custom-select" id="modify-renter-room-number" required="required" style="height: 3.5rem;">
              <option selected="selected" disabled="disabled" hidden="hidden">Room Number *</option> 
              <option value="1A">1A</option>
              <!-- TODO: FROM XML -->
            </select>
           </div>
            <div class="form-floating me-2 flex-fill">
              <input type="text" class="form-control" id="modify-renter-contract-term" placeholder="" required="required"/>
              <label for="modify-renter-contract-term">Contract Term <i>(in months)</i> *</label>
            </div>
            <div class="date-input-container me-2 flex-fill">
              <label for="modify-renter-lease-start" class="date-label">Lease Start <span>*</span></label>
              <label class="date-input-wrapper">
                <input type="date" id="modify-renter-lease-start" class="custom-date-input" required="required"/>
                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
              </label>
            </div>
          </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer d-flex justify-content-between">
          <div id="error-box-modify-renter" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6" style="color:white; background-color: #a6192e;">
            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
            <div>
              <strong class="fs-5">Warning!</strong><br/>
              <span class="small" id="error-text-modify-renter"></span>
            </div>
          </div>
          <div class="ms-auto">
            <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-modify-renter">Cancel</button>
            <button type="button" class="btn-green-fill" id="button-modify-renter">Modify</button>
          </div>
        </div>
      </div>
    </div>
  </div>





  <!-- Modal Modify Renter Confirmation -->
  <div class="modal fade" id="modalModifyRenterConfirmation" tabindex="-1">
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
              <p class="font-red"><span id="confirm-modify-renter-first-name" class="font-red"></span>&#160;<span id="confirm-modify-renter-middle-name"></span>&#160;<span id="confirm-modify-renter-surname"></span>&#160;<span id="confirm-modify-renter-ext-name"></span></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Contact Number:</p>
              <p id="confirm-modify-renter-contact-number" class="font-red"></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Birth Date:</p>
              <p id="confirm-modify-renter-birthdate" class="font-red"></p>
            </div>

            <p class="h4 font-red-gradient mt-3">Valid ID Information</p>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Valid ID Type:</p>
              <p id="confirm-modify-renter-valid-id-type" class="font-red"></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">ID Number:</p>
              <p id="confirm-modify-renter-valid-id-number" class="font-red"></p>
            </div>
          </div>
          
          <div class="d-flex flex-column">
            <p class="h4 font-red-gradient mt-3">Rental Information</p>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Room Number:</p>
              <p><span id="confirm-modify-renter-room-number" class="font-red"></span></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Lease Start:</p>
              <p id="confirm-modify-renter-lease-start" class="font-red"></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Contract Term:</p>
              <p id="confirm-modify-renter-contract-term" class="font-red"></p>
            </div>
          </div>

        </div>

        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn-red me-3" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalModifyRenter">Return</button>
          <form id="modify-renter" method="POST" action="functions/modify-renter.php">
            <input type="hidden" id="hidden-modify-renter-first-name" name="first_name"/>
            <input type="hidden" id="hidden-modify-renter-middle-name" name="middle_name"/>
            <input type="hidden" id="hidden-modify-renter-surname" name="surname"/>
            <input type="hidden" id="hidden-modify-renter-ext-name" name="ext_name"/>
            <input type="hidden" id="hidden-modify-renter-contact-number" name="contact_number"/>
            <input type="hidden" id="hidden-modify-renter-birthdate" name="birthdate"/>
            <input type="hidden" id="hidden-modify-renter-valid-id-type" name="valid_id_type"/>
            <input type="hidden" id="hidden-modify-renter-valid-id-number" name="valid_id_number"/>
            <input type="hidden" id="hidden-modify-renter-room-number" name="room_number"/>
            <input type="hidden" id="hidden-modify-renter-contract-term" name="contract_term"/>
            <input type="hidden" id="hidden-modify-renter-lease-start" name="lease_start"/>
            <input type="hidden" id="hidden-modify-renter-renter-id" name="renter_id"/>
            <input type="hidden" id="hidden-modify-renter-user-id" name="user_id"/>

            <button type="submit" class="btn-green-fill" data-bs-dismiss="modal" id="button-confirm-modify-renter">Confirm</button>
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
            <p class="modal-title h2 font-green text-center">Renter Information Modified Successfully!</p>
          </div>
  
          <!-- Modal body -->
          <div class="modal-body d-flex align-items-center justify-content-center">
            <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
          </div>
  
          <!-- Modal footer -->
          <div class="modal-footer d-flex align-items-center justify-content-center">
            <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-modify-renter">Confirm</button>
          </div>
        </div>
      </div>
    </div>


    <!-- Modal Remove Renter -->
   <!-- TODO: Get Clicked Data from XML -->
  <div class="modal fade" id="modalRemoveRenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header">
          <p class="modal-title h2 font-red-gradient">Remove Renter</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Name:</p>
            <p class="font-red"><span id="remove-renter-first-name" class="font-red"></span>&#160;<span id="remove-renter-middle-name"></span>&#160;<span id="remove-renter-surname"></span>&#160;<span id="remove-renter-ext-name"></span></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Contact Number:</p>
            <p id="remove-renter-contact-number" class="font-red"></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Room Number:</p>
            <p><span id="remove-renter-room-number" class="font-red"></span></p>
          </div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient me-2">Lease Start:</p>
            <p id="remove-renter-lease-start" class="font-red"></p>
          </div>
          <div class="me-2 mb-3 mt-2 flex-fill">
            <select class="form-select custom-select" id="remove-renter-reason" required="required" style="height: 3.5rem;">
              <option value='' selected="selected" disabled="disabled" hidden="hidden">Reason *</option> 
              <option value="end-of-contract">End of Contract</option>
              <option value="voluntary-leave">Voluntary Leave</option>
              <option value="non-payment">Non-payment</option>
              <option value="rule-violation">Violation of House Rules</option>
              <option value="maintenance-issue">Requested Due to Maintenance Issue</option>
              <option value="others">Other</option>
            </select>            
            </div>
            <div class="date-input-container me-2 mt-3 flex-fill">
              <label for="remove-renter-lease-end" class="date-label">Lease End <span>*</span></label>
              <label class="date-input-wrapper">
                <input type="date" id="remove-renter-lease-end" class="custom-date-input" required="required"/>
                <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z"/></svg></span>
              </label>
            </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer d-flex justify-content-between">
          <div id="error-box-remove-renter" class="alert d-none flex-row align-items-start gap-3 p-3 border-0 rounded-3 col-10 col-lg-6" style="color:white; background-color: #a6192e;">
            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
            <div>
              <strong class="fs-5">Warning!</strong><br/>
              <span class="small" id="error-text-remove-renter"></span>
            </div>
          </div>
          <div class="ms-auto">
            <button type="button" class="btn-red" data-bs-dismiss="modal" id="button-cancel-remove-renter">Cancel</button>
            <button type="button" class="btn-red-fill" id="button-remove-renter">Remove</button>
          </div>
        </div>
      </div>
    </div>
  </div>


  <!-- Modal Remove Renter Confirmation -->
  <div class="modal fade" id="modalRemoveRenterConfirmation" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header">
          <p class="modal-title h2 font-red-gradient">Remove Renter Confirmation</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex flex-sm-row flex-column">
          <div class="d-flex flex-column me-5">
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Name:</p>
              <p class="font-red"><span id="confirm-remove-renter-first-name" class="font-red"></span> <span id="confirm-remove-renter-middle-name"></span> <span id="confirm-remove-renter-surname"></span> <span id="confirm-remove-renter-ext-name"></span></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Contact Number:</p>
              <p id="confirm-remove-renter-contact-number" class="font-red"></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Room Number:</p>
              <p><span id="confirm-remove-renter-room-number" class="font-red"></span></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Lease Start:</p>
              <p id="confirm-remove-renter-lease-start" class="font-red"></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Reason:</p>
              <p><span id="confirm-remove-renter-reason" class="font-red"></span></p>
            </div>
            <div class="d-flex flex-row">
              <p class="h5 font-red-gradient me-2">Lease End:</p>
              <p id="confirm-remove-renter-lease-end" class="font-red"></p>
            </div>

          </div>
        

        </div>

        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn-red" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#modalRemoveRenter">Return</button>
          <form id="remove-renter" method="POST" action="functions/remove-renter.php">
            <input type="hidden" id="hidden-remove-renter-reason" name="reason" />
            <input type="hidden" id="hidden-remove-renter-lease-end" name="lease_end" />
            <input type="hidden" id="hidden-remove-renter-renter-id" name="renter_id" />
            <input type="hidden" id="hidden-remove-renter-user-id" name="user_id" />

            <button type="submit" class="btn-red-fill" id="button-confirm-remove-renter" data-bs-dismiss="modal">
                Remove
            </button>
            </form>

        </div>
      </div>
    </div>
  </div>

  <!-- Modal Remove Renter Success -->
  <div class="modal fade" id="modalRemoveRenterSuccess" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-md modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal Header -->
        <div class="modal-header d-flex align-items-center justify-content-center">
          <p class="modal-title h2 font-green text-center">Renter Removed Successfully!</p>
        </div>

        <!-- Modal body -->
        <div class="modal-body d-flex align-items-center justify-content-center">
          <svg xmlns="http://www.w3.org/2000/svg" height="200px" viewBox="0 -960 960 960" width="200px" fill="#6EC456"><path d="m421-298 283-283-46-45-237 237-120-120-45 45 165 166Zm59 218q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z"/></svg>
        </div>

        <!-- Modal footer -->
        <div class="modal-footer d-flex align-items-center justify-content-center">
          <button type="button" class="btn-green-fill" data-bs-dismiss="modal" id="button-success-remove-renter">Confirm</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal View Renter -->
   <!-- TODO: Get Clicked Data from XML -->
   <div class="modal fade" id="modalViewRenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
            <div class="d-flex flex-row align-items-center justify-content-between">
              <p class="h2 font-red-gradient me-2"><span id="view-add-renter-first-name" class="h2"></span>&#160;<span id="view-add-renter-middle-name" class="h2"></span>&#160;<span id="view-add-renter-surname" class="h2"></span>&#160;<span id="view-add-renter-ext-name" class="h2"></span></p>
              <!-- <button type="button" class="btn-red d-flex align-items-center px-3 py-1" data-bs-toggle="modal" data-bs-target="#modalRemoveRenter">
                <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h280v80H200Zm440-160-55-58 102-102H360v-80h327L585-622l55-58 200 200-200 200Z"/></svg>
              </button> -->
              
            </div>
            <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1" data-bs-dismiss="modal">
                <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M400-80 0-480l400-400 71 71-329 329 329 329-71 71Z"/></svg>
                Back
              </button>
            
          </div>
          <div class="horizontal mt-1 mb-2"></div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient">Room <span id="view-add-renter-roomNo"></span> | Lease Start: <span id="view-add-renter-leaseStart"></span></p>
            <!-- <button type="button" class="ms-auto btn-red d-flex align-items-center px-3 py-1" data-bs-toggle="modal" data-bs-target="#modalModifyRenter">
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M200-200h57l391-391-57-57-391 391v57Zm-80 80v-170l528-527q12-11 26.5-17t30.5-6q16 0 31 6t26 18l55 56q12 11 17.5 26t5.5 30q0 16-5.5 30.5T817-647L290-120H120Zm640-584-56-56 56 56Zm-141 85-28-29 57 57-29-28Z"/></svg>
              Edit
            </button> -->
          </div>
          <!-- Nav pills -->
          <div class="nav-pills-red border-bottom border-3 border-danger">
            <ul class="nav nav-pills mt-3">
              <li class="nav-item">
                <a class="nav-link active" data-bs-toggle="pill" href="#information">Information</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" data-bs-toggle="pill" href="#billings">Billings</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" data-bs-toggle="pill" href="#payments">Payments</a>
              </li>
            </ul>
          </div>

          <!-- Tab panes -->
          <div class="tab-content">
            <div class="tab-pane container active" id="information">
                <div class="d-flex flex-wrap mt-2">
                  <div class="d-flex flex-column mb-3 me-5 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white mb-3">Personal Information</p>
                    <!-- <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Name:</p>
                      <p class="font-white"><span id="view-add-renter-first-name" class="font-white"></span> <span id="view-add-renter-middle-name"></span> <span id="view-add-renter-surname"></span> <span id="view-add-renter-ext-name"></span></p>
                    </div> -->
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Contact Number:</p>
                      <p id="view-add-renter-contact-number" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Birth Date:</p>
                      <p id="view-add-renter-birthdate" class="font-white"></p>
                    </div>
                  </div>
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white mb-3">Valid ID Information</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Valid ID Type:</p>
                      <p id="view-add-renter-valid-id-type" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">ID Number:</p>
                      <p id="view-add-renter-valid-id-number" class="font-white"></p>
                    </div>
                  </div>
                  
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white">Rental Information</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Room Number:</p>
                      <p><span id="view-add-renter-room-number" class="font-white"></span></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Lease Start:</p>
                      <p id="view-add-renter-lease-start" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Contract Term:</p>
                      <p id="view-add-renter-contract-term" class="font-white"></p>
                    </div>
                  </div>
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white">Security</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Email Address:</p>
                      <p id="view-add-renter-email" class="font-white"></p>
                    </div>
                  </div>
                </div>
            </div>
            <div class="tab-pane container fade" id="billings">

              <!-- TODO: Populate from XML -->
            <div class="d-flex flex-column align-items-start">
              <div class="d-flex flex-row mt-3">
                <div class="date-input-container ms-2 d-flex flex-row" style="transform: translateY(0%);">
                  <label for="individual-month-due" class="date-label">Month Due</label>
                  <label class="date-input-wrapper ms-2">
                    <input type="month" id="individual-month-due" class="custom-date-input" required="required"/>
                    <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px"
                        viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                        <path
                          d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                      </svg></span>
                  </label>
                </div>
              </div>

              <!-- METRICS -->
              <div class="row gx-3 gy-3 mt-2">
                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-white my-0 text-center">Total Unpaid Bill</p>
                    <p class="h3 font-white my-0 text-center">PHP 7,208.28</p>
                  </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-white my-0 text-center">Total Current Bill</p>
                    <p class="h3 font-white my-0 text-center">PHP 7,208.28</p>
                  </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-red my-0 text-center">Total Current Paid</p>
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
                <p class="h4 font-red-gradient">Individual Breakdown</p>
                <div class="d-flex flex-wrap mt-2 justify-content-between">
                  <div class="col-12 col-sm-6 col-lg-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                          <button type="button" class="btn-white d-flex align-items-center px-3 py-1 "
                            data-bs-toggle="modal" data-bs-target="#modalSendNotificationConfirmation">
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                              fill="#FFFFFF">
                              <path
                                d="M160-200v-80h80v-280q0-83 50-147.5T420-792v-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v28q80 20 130 84.5T720-560v280h80v80H160Zm320-300Zm0 420q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM320-280h320v-280q0-66-47-113t-113-47q-66 0-113 47t-47 113v280Z" />
                            </svg>
                          </button>
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
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Current Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Previous Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Consumed Kwh:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Amount per Kwh:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                        <!-- TODO: Pay Modal -->
                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1">
                          Pay
                        </button>
                      </div>
                    </div>
                  </div>



                  <div class="col-12 col-sm-6 col-lg-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                          <button type="button" class="btn-white d-flex align-items-center px-3 py-1 "
                            data-bs-toggle="modal" data-bs-target="#modalSendNotificationConfirmation">
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                              fill="#FFFFFF">
                              <path
                                d="M160-200v-80h80v-280q0-83 50-147.5T420-792v-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v28q80 20 130 84.5T720-560v280h80v80H160Zm320-300Zm0 420q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM320-280h320v-280q0-66-47-113t-113-47q-66 0-113 47t-47 113v280Z" />
                            </svg>
                          </button>
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
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Current Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Previous Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Consumed m<sup>3</sup>:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Amount per m<sup>3</sup>:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                        <!-- TODO: Pay Modal -->
                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1">
                          Pay
                        </button>
                      </div>
                    </div>
                  </div>



                  <div class="col-12 col-sm-6 col-lg-5 mt-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
                      <div class="d-flex justify-content-between align-items-start w-100">
                        <div class="d-flex align-items-start">
                          <p class="h4 font-white mb-3 me-2 align-self-start">Rent</p>
                          <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                            fill="#FFFFFF">
                            <path
                              d="M760-400v-260L560-800 360-660v60h-80v-100l280-200 280 200v300h-80ZM560-800Zm20 160h40v-40h-40v40Zm-80 0h40v-40h-40v40Zm80 80h40v-40h-40v40Zm-80 0h40v-40h-40v40ZM280-220l278 76 238-74q-5-9-14.5-15.5T760-240H558q-27 0-43-2t-33-8l-93-31 22-78 81 27q17 5 40 8t68 4q0-11-6.5-21T578-354l-234-86h-64v220ZM40-80v-440h304q7 0 14 1.5t13 3.5l235 87q33 12 53.5 42t20.5 66h80q50 0 85 33t35 87v40L560-60l-280-78v58H40Zm80-80h80v-280h-80v280Z" />
                          </svg>
                        </div>

                        <div class="d-flex flex-row">
                          <button type="button" class="btn-white d-flex align-items-center px-3 py-1 "
                            data-bs-toggle="modal" data-bs-target="#modalSendNotificationConfirmation">
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                              fill="#FFFFFF">
                              <path
                                d="M160-200v-80h80v-280q0-83 50-147.5T420-792v-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v28q80 20 130 84.5T720-560v280h80v80H160Zm320-300Zm0 420q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM320-280h320v-280q0-66-47-113t-113-47q-66 0-113 47t-47 113v280Z" />
                            </svg>
                          </button>

                        </div>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Start &amp; Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">End Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                        <!-- TODO: Pay Modal -->
                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1">
                          Pay
                        </button>
                      </div>
                    </div>
                  </div>


                  <div class="col-12 col-sm-6 col-lg-5 mt-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
                      <div class="d-flex justify-content-between align-items-start w-100">
                        <div class="d-flex align-items-start">
                          <p class="h4 font-white mb-3 me-2 align-self-start">Overdue Bills</p>
                          <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                            fill="#FFFFFF">
                            <path
                              d="m40-120 440-760 440 760H40Zm138-80h604L480-720 178-200Zm302-40q17 0 28.5-11.5T520-280q0-17-11.5-28.5T480-320q-17 0-28.5 11.5T440-280q0 17 11.5 28.5T480-240Zm-40-120h80v-200h-80v200Zm40-100Z" />
                          </svg>
                        </div>

                        <div class="d-flex flex-row">
                          <button type="button" class="btn-white d-flex align-items-center px-3 py-1 "
                            data-bs-toggle="modal" data-bs-target="#modalSendNotificationConfirmation">
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px"
                              fill="#FFFFFF">
                              <path
                                d="M160-200v-80h80v-280q0-83 50-147.5T420-792v-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v28q80 20 130 84.5T720-560v280h80v80H160Zm320-300Zm0 420q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM320-280h320v-280q0-66-47-113t-113-47q-66 0-113 47t-47 113v280Z" />
                            </svg>
                          </button>

                        </div>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Electric Overdue:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Water Overdue:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Rent Overdue:</p>
                        <p class="font-white"></p>
                        <div class="d-flex flex-row ms-5">
                          <p class="h6 font-white me-2">Due Date:</p>
                          <p class="font-white"></p>
                        </div>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                        <!-- TODO: Pay Modal -->
                        <button type="button" class="btn-white d-flex align-items-center px-3 py-1">
                          Pay
                        </button>
                      </div>
                    </div>
                  </div>





                </div>

              </div>
            </div>
       


            </div>
            <div class="tab-pane container fade" id="payments">

              <div
                class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                <!-- TODO: Populate from XML -->
                <div class="d-flex flex-column align-items-start w-100">
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
  </div>



  <!-- Modal View Archive Renter -->
   <!-- TODO: Get Clicked Data from XML -->
   <div class="modal fade" id="modalViewArchiveRenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
            <div class="d-flex flex-row align-items-center justify-content-between">
              <p class="h2 font-red-gradient me-2"><span id="view-archive-renter-first-name" class="h2"></span>&#160;<span id="view-archive-renter-middle-name" class="h2"></span>&#160;<span id="view-archive-renter-surname" class="h2"></span>&#160;<span id="view-archive-renter-ext-name" class="h2"></span></p>

              <div class="d-flex align-items-center px-3 py-1" style="border: 0.2rem solid #8f1515;
    background-color: transparent;
    color: #8B0000; /* Maroon text */
    border-radius: 12px;
    padding: 8px 20px;
    font-size: 1.1rem;
    font-weight: bold;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: background-color 0.3s, color 0.3s;">
                Archived</div>
              
            </div>
            <button type="button" class="ms-1 btn-red d-flex align-items-center px-3 py-1" data-bs-dismiss="modal"  data-bs-toggle="modal" data-bs-target="#modalArchiveRenter">
                <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M400-80 0-480l400-400 71 71-329 329 329 329-71 71Z"/></svg>
                Back
              </button>
            
          </div>
          <div class="horizontal mt-1 mb-2"></div>
          <div class="d-flex flex-row">
            <p class="h5 font-red-gradient">Room <span id="view-archive-renter-roomNo"></span> | Lease Period: <span id="view-archive-renter-leaseStart"></span> to <span id="view-archive-renter-leaseEnd"></span></p>
          </div>
          <!-- Nav pills -->
          <div class="nav-pills-red border-bottom border-3 border-danger">
            <ul class="nav nav-pills mt-3">
              <li class="nav-item">
                <a class="nav-link active" data-bs-toggle="pill" href="#informationArchive">Information</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" data-bs-toggle="pill" href="#billingsArchive">Billings</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" data-bs-toggle="pill" href="#paymentsArchive">Payments</a>
              </li>
            </ul>
          </div>

          <!-- Tab panes -->
          <div class="tab-content">
            <div class="tab-pane container active" id="informationArchive">
                <div class="d-flex flex-wrap mt-2">
                  <div class="d-flex flex-column mb-3 me-5 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white mb-3">Personal Information</p>
                    <!-- <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Name:</p>
                      <p class="font-white"><span id="view-archive-renter-first-name" class="font-red"></span> <span id="view-archive-renter-middle-name"></span> <span id="view-archive-renter-surname"></span> <span id="view-archive-renter-ext-name"></span></p>
                    </div> -->
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Contact Number:</p>
                      <p id="view-archive-renter-contact-number" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Birth Date:</p>
                      <p id="view-archive-renter-birthdate" class="font-white"></p>
                    </div>
                  </div>
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white mb-3">Valid ID Information</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Valid ID Type:</p>
                      <p id="view-archive-renter-valid-id-type" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">ID Number:</p>
                      <p id="view-archive-renter-valid-id-number" class="font-white"></p>
                    </div>
                  </div>
                  
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white">Rental Information</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Room Number:</p>
                      <p><span id="view-archive-renter-room-number" class="font-white"></span></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Lease Start:</p>
                      <p id="view-archive-renter-lease-start" class="font-white"></p>
                    </div>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Contract Term:</p>
                      <p id="view-archive-renter-contract-term" class="font-white"></p>
                    </div>
                  </div>
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white">Security</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Email Address:</p>
                      <p id="view-archive-renter-email" class="font-white"></p>
                    </div>
                  </div>
                  <div class="d-flex flex-column me-5 mb-3 gradient-red-bg p-4 rounded-3">
                    <p class="h4 font-white">Leaving Reason</p>
                    <div class="d-flex flex-row">
                      <p class="h5 font-white me-2">Reason For Leaving:</p>
                      <p id="view-archive-renter-leaving-reason" class="font-white"></p>
                    </div>
                  </div>
                </div>
            </div>
            <div class="tab-pane container fade" id="billingsArchive">

              <!-- TODO: Populate from XML -->
            <div class="d-flex flex-column align-items-start">
              <div class="d-flex flex-row mt-3">
                <div class="date-input-container ms-2 d-flex flex-row" style="transform: translateY(0%);">
                  <label for="individual-month-due" class="date-label">Month Due</label>
                  <label class="date-input-wrapper ms-2">
                    <input type="month" id="individual-month-due" class="custom-date-input" required="required"/>
                    <span class="calendar-icon"><svg xmlns="http://www.w3.org/2000/svg" height="24px"
                        viewBox="0 -960 960 960" width="24px" fill="#8B0000">
                        <path
                          d="M200-80q-33 0-56.5-23.5T120-160v-560q0-33 23.5-56.5T200-800h40v-80h80v80h320v-80h80v80h40q33 0 56.5 23.5T840-720v560q0 33-23.5 56.5T760-80H200Zm0-80h560v-400H200v400Zm0-480h560v-80H200v80Zm0 0v-80 80Zm280 240q-17 0-28.5-11.5T440-440q0-17 11.5-28.5T480-480q17 0 28.5 11.5T520-440q0 17-11.5 28.5T480-400Zm-160 0q-17 0-28.5-11.5T280-440q0-17 11.5-28.5T320-480q17 0 28.5 11.5T360-440q0 17-11.5 28.5T320-400Zm320 0q-17 0-28.5-11.5T600-440q0-17 11.5-28.5T640-480q17 0 28.5 11.5T680-440q0 17-11.5 28.5T640-400ZM480-240q-17 0-28.5-11.5T440-280q0-17 11.5-28.5T480-320q17 0 28.5 11.5T520-280q0 17-11.5 28.5T480-240Zm-160 0q-17 0-28.5-11.5T280-280q0-17 11.5-28.5T320-320q17 0 28.5 11.5T360-280q0 17-11.5 28.5T320-240Zm320 0q-17 0-28.5-11.5T600-280q0-17 11.5-28.5T640-320q17 0 28.5 11.5T680-280q0 17-11.5 28.5T640-240Z" />
                      </svg></span>
                  </label>
                </div>
              </div>

              <!-- METRICS -->
              <div class="row gx-3 gy-3 mt-2">
                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-white my-0 text-center">Total Unpaid Bill</p>
                    <p class="h3 font-white my-0 text-center">PHP 7,208.28</p>
                  </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="gradient-red-bg d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-white my-0 text-center">Total Current Bill</p>
                    <p class="h3 font-white my-0 text-center">PHP 7,208.28</p>
                  </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                  <div
                    class="red-border d-flex flex-column align-items-center justify-content-center rounded-4 p-3 px-4 h-100">
                    <p class="h6 font-red my-0 text-center">Total Current Paid</p>
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
                <p class="h4 font-red-gradient">Individual Breakdown</p>
                <div class="d-flex flex-wrap mt-2 justify-content-between">
                  <div class="col-12 col-sm-6 col-lg-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Current Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Previous Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Consumed Kwh:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Amount per Kwh:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                       
                      </div>
                    </div>
                  </div>



                  <div class="col-12 col-sm-6 col-lg-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Current Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Previous Reading:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Consumed m<sup>3</sup>:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Amount per m<sup>3</sup>:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                  
                      </div>
                    </div>
                  </div>



                  <div class="col-12 col-sm-6 col-lg-5 mt-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                        <p class="h6 font-white me-2">Start amp; Due Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">End Date:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                     
                      </div>
                    </div>
                  </div>


                  <div class="col-12 col-sm-6 col-lg-5 mt-5">
                    <div class="gradient-red-bg d-flex flex-column align-items-start rounded-4 p-4 px-4 h-100">
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
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Water Overdue:</p>
                        <p class="font-white"></p>
                      </div>
                      <div class="d-flex flex-row">
                        <p class="h6 font-white me-2">Rent Overdue:</p>
                        <p class="font-white"></p>
                        <div class="d-flex flex-row ms-5">
                          <p class="h6 font-white me-2">Due Date:</p>
                          <p class="font-white"></p>
                        </div>
                      </div>
                      <div class="d-flex flex-row justify-content-between w-100">
                        <div class="d-flex flex-row">
                          <p class="h4 font-white me-2">Your Bill:</p>
                          <p class="font-white"></p>
                        </div>
                     
                      </div>
                    </div>
                  </div>





                </div>

              </div>
            </div>
       


            </div>
            <div class="tab-pane container fade" id="paymentsArchive">

              <div
                class="d-flex flex-sm-row flex-column justify-content-between align-items-start mt-3">
                <!-- TODO: Populate from XML -->
                <div class="d-flex flex-column align-items-start w-100">
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
  </div>




  <!-- Modal Archive Renter -->
   <!-- TODO: Get Clicked Data from XML -->
   <div class="modal fade" id="modalArchiveRenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-xl modal-fullscreen-md-down">
      <div class="modal-content p-4">

        <!-- Modal body -->
        <div class="modal-body d-flex flex-column">
          <div class="d-flex flex-sm-row flex-column justify-content-between align-items-start">
            <p class="h2 font-red-gradient me-2">Renter Archives</p>
            <button type="button" class="ms-auto btn-red d-flex align-items-center px-3 py-1" data-bs-dismiss="modal">
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#8B0000"><path d="M400-80 0-480l400-400 71 71-329 329 329 329-71 71Z"/></svg>
              Back
            </button>
          
          </div>
          <div class="horizontal mt-1 mb-2"></div>
          

        <!-- TABLE -->
        <table class="custom-table" id="renter-archive-information-table">
          <thead>
            <tr>
              <th>Room No.</th>
              <th>Renter Name</th>
              <th>Contact Number</th>
              <th>Lease Ended</th>
              <th>Status</th>
              <th class="text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="$data/apartmentManagement/renters/renter">
                <xsl:if test="status = 'Archived'">
                    <tr>
                    <td><xsl:value-of select="rentalInfo/unitId"/></td>
                    <td>
                        <xsl:value-of select="personalInfo/name/firstName"/>&#160;
                        <xsl:value-of select="personalInfo/name/middleName"/>&#160;
                        <xsl:value-of select="personalInfo/name/surname"/>&#160;
                        <xsl:value-of select="personalInfo/name/extension"/>
                    </td>
                    <td><xsl:value-of select="personalInfo/contact"/></td>
                    <td><xsl:value-of select="rentalInfo/leaseEnd"/></td>
                    <td>
                        <div class="d-flex justify-content-center align-items-center">
                        <span class="badge rounded-pill bg-danger" id="status">
                            <xsl:value-of select="status"/>
                        </span>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex flex-row justify-content-center align-items-center align-self-center">

                        <!-- Extract renter ID -->
                        <xsl:variable name="renterId" select="@id"/>
                        <xsl:variable name="userId" select="userId"/>

                        <!-- VIEW button -->
                        <button type="button" class="ms-1 btn-red-fill d-flex align-items-center px-3 py-1 button-table-view-archive-renter" data-bs-toggle="modal" data-bs-target="#modalViewArchiveRenter">
                          <xsl:attribute name="data-renter-id">
                            <xsl:value-of select="$renterId"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-user-id">
                            <xsl:value-of select="$userId"/>
                            </xsl:attribute>
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF"><path d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z"/></svg>
                        </button>
                        </div>
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




</body>

</html>
        </xsl:template>
    </xsl:stylesheet>