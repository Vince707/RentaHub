$(window).on('load', function () {
  // Fade out the loading screen
  $('#loading-screen').fadeOut('slow', function () {
    $('#main-content').fadeIn('slow');
  });
});


let date = new Date(); // use let to allow updating
const options = {
  year: "numeric",
  month: "long",
  day: "numeric",
  hour: "numeric",
  minute: "2-digit",
  hour12: true,
};

function formatDateToYYYYMMDD(dateObj) {
  const year = dateObj.getFullYear();
  const month = String(dateObj.getMonth() + 1).padStart(2, '0');
  const day = String(dateObj.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

let renterDataMap = {};

$.ajax({
  url: 'apartment.xml',
  dataType: 'xml',
  success: function (xml) {
    $(xml).find('renter').each(function () {
      const id = $(this).attr('id');

      renterDataMap[id] = {
        userId: $(this).find('userId').text().trim(),
        status: $(this).find('status').text().trim(),
        surname: $(this).find('personalInfo > name > surname').text().trim(),
        firstName: $(this).find('personalInfo > name > firstName').text().trim(),
        middleName: $(this).find('personalInfo > name > middleName').text().trim(),
        extension: $(this).find('personalInfo > name > extension').text().trim(),
        contact: $(this).find('personalInfo > contact').text().trim(),
        birthDate: $(this).find('personalInfo > birthDate').text().trim(),
        validIdType: $(this).find('personalInfo > validId > validIdType').text().trim(),
        validIdNumber: $(this).find('personalInfo > validId > validIdNumber').text().trim(),
        unitId: $(this).find('rentalInfo > unitId').text().trim(),
        leaseStart: $(this).find('rentalInfo > leaseStart').text().trim(),
        leaseEnd: $(this).find('rentalInfo > leaseEnd').text().trim(),
        contractTermInMonths: $(this).find('rentalInfo > contractTermInMonths').text().trim(),
        leavingReason: $(this).find('rentalInfo > leavingReason').text().trim()
      };
    });
  }
});

function displaySuccessModal(){
  const url = new URL(window.location.href);
  const urlParams = url.searchParams;
  const renterAction = urlParams.get('renter');

    switch (renterAction) {
      case 'modified':
        $('#modalModifyRenterSuccess').modal('show');
        break;

      case 'added':
        $('#modalAddRenterSuccess').modal('show');
        break;

      case 'archived':
        $('#modalRemoveRenterSuccess').modal('show');
        break;

      default:
        // Do nothing or handle unknown action
        break;
    }

   // Clean URL (remove all search parameters)
    url.search = '';
    window.history.replaceState({}, document.title, url.toString());
}

$(document).ready(function () {
  displaySuccessModal();
  const today = formatDateToYYYYMMDD(new Date());
  $('#add-renter-birthdate').attr('max', today);
  $('#modify-renter-birthdate').attr('max', today);

  const formattedDate = date.toLocaleString("en-US", options);
  $(".current-date").text(formattedDate.replace("at ", ""));

  const currentYear = new Date().getFullYear();
  $(".current-year").text(currentYear);

  setInterval(updateTime, 1000);

  $('#button-add-renter').on("click", function () {
    // Collect input values
    const surname = $("#add-renter-surname").val().trim();
    const firstName = $("#add-renter-first-name").val().trim();
    const middleName = $("#add-renter-middle-name").val().trim();
    const extName = $("#add-renter-ext-name").val().trim();
    const contact = $("#add-renter-contact-number").val().trim();
    const idType = $("#add-renter-valid-id-type").val();
    const idNumber = $("#add-renter-valid-id-number").val().trim();
    const room = $("#add-renter-room-number").val();
    const contractTerm = $("#add-renter-contract-term").val().trim();
    const email = $("#add-renter-email").val().trim();
    const password = $("#add-renter-password").val().trim();
    const birthdate = $("#add-renter-birthdate").val();
    const leaseStart = $("#add-renter-lease-start").val();
    const confirmPassword = $("#add-renter-confirm-password").val().trim();


    if (!surname || !firstName || !contact || !birthdate || !idType || !idNumber || !room || !contractTerm || !leaseStart || !email || !password || !confirmPassword) {
      return showError("All required fields must be filled.", "#error-box-add-renter", "#error-text-add-renter");
    }

  
    // Check for whitespace-only inputs
    if ([surname, firstName, contact, idNumber, email, password, confirmPassword].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-add-renter", "#error-text-add-renter");
    }
  
    // Length validation
    if ([surname, firstName, middleName, extName, contact, idNumber, email, password].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-add-renter", "#error-text-add-renter");
    }
  
    // Name validation
    if (![surname, firstName, middleName, extName].every(isValidName)) {
      return showError("One or more names contain invalid characters.", "#error-box-add-renter", "#error-text-add-renter");
    }
  
    // Contact number
    if (!isNumber(contact)) {
      return showError("Contact number must be numeric only.", "#error-box-add-renter", "#error-text-add-renter");
    }
    if (!isValidPhoneNum(contact)) {
      return showError("Contact number must be in 09XXXXXXXXX format.", "#error-box-add-renter", "#error-text-add-renter");
    }

    if (isAfterToday(birthdate)) {
      return showError("Birth Date must not be after today.", "#error-box-add-renter", "#error-text-add-renter");
    }
    
    
    if (!isNumber(contractTerm)) {
      return showError("Contract Term must be numeric only [in months].", "#error-box-add-renter", "#error-text-add-renter");
    }

    // ID number validation
    if (!isValidIDNumber(idNumber)) {
      return showError("Invalid characters in ID number.", "#error-box-add-renter", "#error-text-add-renter");
    }
  
    // Email validation
    if (!isValidEmailChars(email)) return showError("Email contains invalid characters.", "#error-box-add-renter", "#error-text-add-renter");
    if (!isValidEmailFormat(email)) return showError("Invalid email format.", "#error-box-add-renter", "#error-text-add-renter");
  
    // Password validation
    if (password !== confirmPassword) return showError("Password do not match.", "#error-box-add-renter", "#error-text-add-renter");
    if (!isValidPasswordChars(password)) return showError("Password contains invalid characters.", "#error-box-add-renter", "#error-text-add-renter");
    const passwordCheck = isStrongPassword(password);
    if (!passwordCheck.isValid) return showError(passwordCheck.errors.join("<br/>"), "#error-box-add-renter", "#error-text-add-renter");
  
    // Fill confirmation modal
    $("#confirm-add-renter-first-name").text(firstName);
    $("#confirm-add-renter-middle-name").text(middleName);
    $("#confirm-add-renter-surname").text(surname);
    $("#confirm-add-renter-ext-name").text(extName);
    $("#confirm-add-renter-contact-number").text(contact);
    $("#confirm-add-renter-birthdate").text(birthdate);
    $("#confirm-add-renter-valid-id-type").text(idType);
    $("#confirm-add-renter-valid-id-number").text(idNumber);
    $("#confirm-add-renter-room-number").text(room);
    $("#confirm-add-renter-contract-term").text(contractTerm);
    $("#confirm-add-renter-lease-start").text(leaseStart);
    $("#confirm-add-renter-email").text(email);
  

    // FILL Hidden form for PHP
    $("#hidden-add-renter-first-name").val(firstName);
    $("#hidden-add-renter-middle-name").val(middleName);
    $("#hidden-add-renter-surname").val(surname);
    $("#hidden-add-renter-ext-name").val(extName);
    $("#hidden-add-renter-contact-number").val(contact);
    $("#hidden-add-renter-birthdate").val(birthdate);
    $("#hidden-add-renter-valid-id-type").val(idType);
    $("#hidden-add-renter-valid-id-number").val(idNumber);
    $("#hidden-add-renter-room-number").val(room);
    $("#hidden-add-renter-contract-term").val(contractTerm);
    $("#hidden-add-renter-lease-start").val(leaseStart);
    $("#hidden-add-renter-email").val(email);
    $("#hidden-add-renter-password").val(password);

    $('#modalAddRenter').modal('hide');
    $('#modalAddRenterConfirmation').modal('show');
    hideError("#error-box-add-renter", "#error-text-add-renter");
  });


  $('#button-modify-renter').on("click", function () {
    // Collect input values
    const surname = $("#modify-renter-surname").val().trim();
    const firstName = $("#modify-renter-first-name").val().trim();
    const middleName = $("#modify-renter-middle-name").val().trim();
    const extName = $("#modify-renter-ext-name").val().trim();
    const contact = $("#modify-renter-contact-number").val().trim();
    const idType = $("#modify-renter-valid-id-type").val();
    const idNumber = $("#modify-renter-valid-id-number").val().trim();
    const room = $("#modify-renter-room-number").val();
    const contractTerm = $("#modify-renter-contract-term").val().trim();
    const birthdate = $("#modify-renter-birthdate").val();
    const leaseStart = $("#modify-renter-lease-start").val();


    if (!surname || !firstName || !contact || !birthdate || !idType || !idNumber || !room || !contractTerm || !leaseStart) {
      return showError("All required fields must be filled.", "#error-box-modify-renter", "#error-text-modify-renter");
    }

  
    // Check for whitespace-only inputs
    if ([surname, firstName, contact, idNumber].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
  
    // Length validation
    if ([surname, firstName, middleName, extName, contact, idNumber].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
  
    // Name validation
    if (![surname, firstName, middleName, extName].every(isValidName)) {
      return showError("One or more names contain invalid characters.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
  
    // Contact number
    if (!isNumber(contact)) {
      return showError("Contact number must be numeric only.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
    if (!isValidPhoneNum(contact)) {
      return showError("Contact number must be in 09XXXXXXXXX format.", "#error-box-modify-renter", "#error-text-modify-renter");
    }

    if (isAfterToday(birthdate)) {
      return showError("Birth Date must not be after today.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
    
    
    if (!isNumber(contractTerm)) {
      return showError("Contract Term must be numeric only [in months].", "#error-box-modify-renter", "#error-text-modify-renter");
    }

    // ID number validation
    if (!isValidIDNumber(idNumber)) {
      return showError("Invalid characters in ID number.", "#error-box-modify-renter", "#error-text-modify-renter");
    }
  
  
    // Fill confirmation modal
    $("#confirm-modify-renter-first-name").text(firstName);
    $("#confirm-modify-renter-middle-name").text(middleName);
    $("#confirm-modify-renter-surname").text(surname);
    $("#confirm-modify-renter-ext-name").text(extName);
    $("#confirm-modify-renter-contact-number").text(contact);
    $("#confirm-modify-renter-birthdate").text(birthdate);
    $("#confirm-modify-renter-valid-id-type").text(idType);
    $("#confirm-modify-renter-valid-id-number").text(idNumber);
    $("#confirm-modify-renter-room-number").text(room);
    $("#confirm-modify-renter-contract-term").text(contractTerm);
    $("#confirm-modify-renter-lease-start").text(leaseStart);

    // FILL Hidden form for PHP
    $("#hidden-modify-renter-first-name").val(firstName);
    $("#hidden-modify-renter-middle-name").val(middleName);
    $("#hidden-modify-renter-surname").val(surname);
    $("#hidden-modify-renter-ext-name").val(extName);
    $("#hidden-modify-renter-contact-number").val(contact);
    $("#hidden-modify-renter-birthdate").val(birthdate);
    $("#hidden-modify-renter-valid-id-type").val(idType);
    $("#hidden-modify-renter-valid-id-number").val(idNumber);
    $("#hidden-modify-renter-room-number").val(room);
    $("#hidden-modify-renter-contract-term").val(contractTerm);
    $("#hidden-modify-renter-lease-start").val(leaseStart);
    $("#hidden-modify-renter-user-id").val(leaseStart);
  
    $('#modalModifyRenter').modal('hide');
    $('#modalModifyRenterConfirmation').modal('show');
    hideError("#error-box-modify-renter", "#error-text-modify-renter");
  });

  $('#button-remove-renter').on("click", function () {
    // Collect input values
    const reason = $("#remove-renter-reason").val();
    const leaseEnd = $("#remove-renter-lease-end").val();
    // TODO: ADD CONDITION LEASE END NOT BEFORE LEASE START

    if (!reason || !leaseEnd) {
      return showError("All required fields must be filled.", "#error-box-remove-renter", "#error-text-remove-renter");
    }
  
    // Fill confirmation modal
    $("#confirm-remove-renter-reason").text(reason);
    $("#confirm-remove-renter-lease-end").text(leaseEnd);

    // FILL Hidden form for PHP
    $("#hidden-remove-renter-reason").val(reason);
    $("#hidden-remove-renter-lease-end").val(leaseEnd);
  
    $('#modalRemoveRenter').modal('hide');
    $('#modalRemoveRenterConfirmation').modal('show');
    hideError("#error-box-remove-renter", "#error-text-remove-renter");
  });






  $('#button-success-add-renter').on("click", function () {
    clearFieldsAddRenter();
    // TODO: save to xml
  });

  $('#button-cancel-add-renter').on("click", function () {
    clearFieldsAddRenter();
    hideError();
  });

  $('#button-success-modify-renter').on("click", function () {
    clearFieldsModifyRenter();
    // TODO: save to xml
  });

  $('#button-cancel-modify-renter').on("click", function () {
    clearFieldsModifyRenter();
    hideError();
  });

  $('#button-success-remove-renter').on("click", function () {
    clearFieldsRemoveRenter();
    // TODO: save to xml
  });

  $('#button-cancel-remove-renter').on("click", function () {
    clearFieldsRemoveRenter();
    hideError();
  });


  $('#button-add-task').on("click", function () {
    $('#modalAddTask').modal('hide');
    $('#modalAddTaskConfirmation').modal('show');
  });

  $('#button-confirm-send-notif').on("click", function () {
    const renterID = $('#select-billings-renter').val();
    $('#modalSendNotificationConfirmation').modal('hide');
    $('#modalSendNotificationSuccess').modal('show');
    // TODO: Set renter name for modal
    // TODO: Renter ID
    sendNotification(renterID);
  });

  $('#button-generate-electric').on("click", function () {
    // TODO: PROCESS
    $('#modalGenerateElectricBill').modal('hide');
    $('#modalGenerateElectricBillConfirmation').modal('show');

    // Collect input values
    const monthDue = $("#generate-electric-bill-month-due").val().trim();
    const totalBill = $("#add-billings-electric-total-bill").val().trim();
    // TODO: 05/11-12 Sunday Night: NOT YET DONE KASI CONNECT MUNA DAPAT

    // VALIDATIONS
    if (!monthDue || !totalBill) {
      return showError("All required fields must be filled.", "#error-box-modify-renter", "#error-text-modify-renter");
    }

    


  });

  $('#button-confirm-generate-electric').on("click", function () {
    // TODO: XML Write Save
    // TODO: Clear
  });

  $('#button-generate-water').on("click", function () {
    // TODO: PROCESS
    $('#modalGenerateWaterBill').modal('hide');
    $('#modalGenerateWaterBillConfirmation').modal('show');
  });

  $('#button-confirm-generate-water').on("click", function () {
    // TODO: XML Write Save
    // TODO: Clear
  });

  $('#button-modify-electric').on("click", function () {
    // TODO: PROCESS
    $('#modalModifyElectricBill').modal('hide');
    $('#modalModifyElectricBillConfirmation').modal('show');
  });

   $('#button-confirm-modify-electric').on("click", function () {
    // TODO: XML Write Save
    // TODO: Clear
  });

  $('#button-modify-water').on("click", function () {
    // TODO: PROCESS
    $('#modalModifyWaterBill').modal('hide');
    $('#modalModifyWaterBillConfirmation').modal('show');
  });

   $('#button-confirm-modify-water').on("click", function () {
    // TODO: XML Write Save
    // TODO: Clear
  });

  $('#button-modify-electric-metadata').on("click", function () {
    // Collect input values
    const customerAccountName = $("#modify-electric-customer-account-name").val().trim();
    const customerAccountNumber = $("#modify-electric-customer-account-number").val().trim();
    const meterNumber = $("#modify-electric-meter-number").val().trim();
    const address = $("#modify-electric-address").val().trim();

    // VALIDATIONS
    if (!customerAccountName || !customerAccountNumber || !meterNumber || !address) {
      return showError("All required fields must be filled.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }    

    // Check for whitespace-only inputs
    if ([customerAccountName, customerAccountNumber, meterNumber, address].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }
  
    // Length validation
    if ([customerAccountName, customerAccountNumber, meterNumber, address].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }

    // Fill confirmation modal
    $("#confirm-modify-electric-metadata-customer-account-name").text(customerAccountName);
    $("#confirm-modify-electric-metadata-customer-account-number").text(customerAccountNumber);
    $("#confirm-modify-electric-metadata-meter-number").text(meterNumber);
    $("#confirm-modify-electric-metadata-address").text(address);

    // TODO: PROCESS
    $('#modalModifyElectricMetadata').modal('hide');
    $('#modalModifyElectricMetadataConfirmation').modal('show');
    hideError("#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  });

   $('#button-confirm-modify-electric-metadata').on("click", function () {
    // TODO: XML Write Save
    clearFieldsByIds([
  "modify-electric-customer-account-name",
  "modify-electric-customer-account-number",
  "modify-electric-meter-number",
  "modify-electric-address"
]);
  });

  $('#button-modify-water-metadata').on("click", function () {
   // Collect input values
    const customerAccountName = $("#modify-water-customer-account-name").val().trim();
    const customerAccountNumber = $("#modify-water-customer-account-number").val().trim();
    const meterNumber = $("#modify-water-meter-number").val().trim();
    const address = $("#modify-water-address").val().trim();

    // VALIDATIONS
    if (!customerAccountName || !customerAccountNumber || !meterNumber || !address) {
      return showError("All required fields must be filled.", "#error-box-modify-water-metadata", "#error-text-water-metadata");
    }    

    // Check for whitespace-only inputs
    if ([customerAccountName, customerAccountNumber, meterNumber, address].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-modify-water-metadata", "#error-text-water-metadata");
    }
  
    // Length validation
    if ([customerAccountName, customerAccountNumber, meterNumber, address].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-modify-water-metadata", "#error-text-water-metadata");
    }

    // Fill confirmation modal
    $("#confirm-modify-water-metadata-customer-account-name").text(customerAccountName);
    $("#confirm-modify-water-metadata-customer-account-number").text(customerAccountNumber);
    $("#confirm-modify-water-metadata-meter-number").text(meterNumber);
    $("#confirm-modify-water-metadata-address").text(address);

    // TODO: PROCESS
    $('#modalModifyWaterMetadata').modal('hide');
    $('#modalModifyWaterMetadataConfirmation').modal('show');
    hideError("#error-box-modify-water-metadata", "#error-text-water-metadata");
  });

   $('#button-confirm-modify-water-metadata').on("click", function () {
    // TODO: XML Write Save
    clearFieldsByIds([
  "modify-water-customer-account-name",
  "modify-water-customer-account-number",
  "modify-water-meter-number",
  "modify-water-address"
]);
  });

  $('#button-record-payment').on("click", function () {
     // Collect input values
    //  TODO: Generate RECEIPT ID
    const renterName = $("#record-payment-renter").val();
    const paymentTypes = [];
    if ($("#record-payment-electric-checkbox").is(":checked")) paymentTypes.push("electric");
    if ($("#record-payment-water-checkbox").is(":checked")) paymentTypes.push("water");
    if ($("#record-payment-rent-checkbox").is(":checked")) paymentTypes.push("rent");

    const paymentDate = $("#record-payment-payment-date").val().trim();
    const paymentAmount = $("#record-payment-payment-amount").val().trim();
    const paymentMethod = $("#record-payment-method").val(); 
    const paymentAmountType = $("#record-payment-amount-type").val();
    const remarks = $("#record-payment-remarks").val().trim();


    // VALIDATIONS
    if (!renterName || !paymentTypes || !paymentDate || !paymentAmount || !paymentMethod || !paymentAmountType) {
      return showError("All required fields must be filled.", "#error-box-record-payment", "#error-text-record-payment");
    }    

    // Check for whitespace-only inputs
    if ([renterName, paymentTypes, paymentDate, paymentAmount, paymentMethod, paymentAmountType].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-record-payment", "#error-text-record-payment");
    }
  
    // Length validation
    if ([renterName, paymentTypes, paymentDate, paymentAmount, paymentMethod, paymentAmountType, remarks].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-record-payment", "#error-text-record-payment");
    }

    if (!isNumber(paymentAmount)) {
      return showError("Payment amount must be numeric only.", "#error-box-record-payment", "#error-text-record-payment");
    }

    // Fill confirmation modal
    $("#confirm-record-renter-name").text(renterName);
    $("#confirm-record-payment-type").text(paymentTypes.join(", "));
    $("#confirm-record-payment-date").text(paymentDate);
    $("#confirm-record-payment-amount").text(paymentAmount);
    $("#confirm-record-payment-method").text(paymentMethod);
    $("#confirm-record-payment-amount-type").text(paymentAmountType);
    $("#confirm-record-payment-remarks").text(remarks);

    $('#modalRecordPayment').modal('hide');
    $('#modalRecordPaymentConfirmation').modal('show');
    hideError("#error-box-record-payment", "#error-text-record-payment");
  });

   $('#button-confirm-record-payment').on("click", function () {
    // TODO: XML Write Save
  clearFieldsByIds([
  "record-payment-renter",
  "record-payment-electric-checkbox",
  "record-payment-water-checkbox",
  "record-payment-rent-checkbox",
  "record-payment-payment-date",
  "record-payment-payment-amount",
  "record-payment-method",
  "record-payment-amount-type",
  "record-payment-remarks"
]);
$('#record-payment-electric-checkbox').prop('checked', false);
$('#record-payment-water-checkbox').prop('checked', false);
$('#record-payment-rent-checkbox').prop('checked', false);

  });
  $('#button-success-record-payment-notify').on("click", function () {
    // TODO: Notify Renter
  });


  $('#button-login').on("click", function () {
    // Collect input values
    const email = $("#modify-electric-customer-account-name").val().trim();
    const password = $("#modify-electric-customer-account-number").val().trim();

    // VALIDATIONS
    if (!email || !password) {
      return showError("All required fields must be filled.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }    

    // Check for whitespace-only inputs
    if ([email, password].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }
  
    // Length validation
    if ([email, password].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
    }

    // Fill confirmation modal
    $("#confirm-modify-electric-metadata-customer-account-name").text(customerAccountName);
    $("#confirm-modify-electric-metadata-customer-account-number").text(customerAccountNumber);
    $("#confirm-modify-electric-metadata-meter-number").text(meterNumber);
    $("#confirm-modify-electric-metadata-address").text(address);

    // TODO: PROCESS
    $('#modalModifyElectricMetadata').modal('hide');
    $('#modalModifyElectricMetadataConfirmation').modal('show');
    hideError("#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  });








});

$(document).on("click", ".button-table-modify-renter", function () {
  const renterId = $(this).data('renter-id');
  const renter = renterDataMap[renterId];

  if (renter) {
    $('#modify-renter-surname').val(renter.surname);
    $('#modify-renter-first-name').val(renter.firstName);
    $('#modify-renter-middle-name').val(renter.middleName);
    $('#modify-renter-ext-name').val(renter.extension);
    $('#modify-renter-contact-number').val(renter.contact);
    $('#modify-renter-birthdate').val(renter.birthDate);
    $('#modify-renter-valid-id-type').val(renter.validIdType);
    $('#modify-renter-valid-id-number').val(renter.validIdNumber);
    $('#modify-renter-room-number').val(renter.unitId);
    $('#modify-renter-contract-term').val(renter.contractTermInMonths);
    $('#modify-renter-lease-start').val(renter.leaseStart);
    $('#modify-renter-lease-end').val(renter.leaseEnd);
    $('#modify-renter-leaving-reason').val(renter.leavingReason);
    $("#hidden-modify-renter-renter-id").val(renterId);
    $("#hidden-modify-renter-user-id").val(renter.userId);
  } else {
    alert("Renter data not found.");
  }
});

$(document).on("click", ".button-table-remove-renter", function () {
  const renterId = $(this).data('renter-id');
  const renter = renterDataMap[renterId];

  if (renter) {
    $('#remove-renter-first-name').text(renter.firstName);
    $('#remove-renter-middle-name').text(renter.middleName);
    $('#remove-renter-surname').text(renter.surname);
    $('#remove-renter-ext-name').text(renter.extension || ''); // in case ext is null
    $('#remove-renter-contact-number').text(renter.contact);
    $('#remove-renter-room-number').text(renter.unitId);
    $('#remove-renter-lease-start').text(renter.leaseStart);

    $('#confirm-remove-renter-first-name').text(renter.firstName);
    $('#confirm-remove-renter-middle-name').text(renter.middleName);
    $('#confirm-remove-renter-surname').text(renter.surname);
    $('#confirm-remove-renter-ext-name').text(renter.extension || ''); // in case ext is null
    $('#confirm-remove-renter-contact-number').text(renter.contact);
    $('#confirm-remove-renter-room-number').text(renter.unitId);
    $('#confirm-remove-renter-lease-start').text(renter.leaseStart);

    $("#hidden-remove-renter-renter-id").val(renterId);
    $("#hidden-remove-renter-user-id").val(renter.userId);
    // You can also store renterId in a hidden input or data attribute if needed for backend deletion
    $('#button-remove-renter').data('renter-id', renterId);
  } else {
    alert("Renter data not found.");
  }
});



function sendNotification(renterID){
  // TODO: Send Notification
}
  
function updateTime() {
  date = new Date(date.getTime() + 1000);
  const formattedDate = date.toLocaleString("en-US", options);
  $(".current-date").text(formattedDate.replace("at ", ""));
}

function clearFieldsByIds(ids) {
  ids.forEach(function(id) {
    $("#" + id).val('');
  });
}

// TODO: Change these clear fields and test the dynamic ^^^^
function clearFieldsAddRenter(){
  $("#add-renter-surname").val('');
  $("#add-renter-first-name").val('');
  $("#add-renter-middle-name").val('');
  $("#add-renter-ext-name").val('');
  $("#add-renter-contact-number").val('');
  $("#add-renter-valid-id-type").val('Valid ID Type *'); 
  $("#add-renter-valid-id-number").val('');
  $("#add-renter-room-number").val('Room Number *'); 
  $("#add-renter-contract-term").val(''); 
  $("#add-renter-email").val('');
  $("#add-renter-password").val('');
  $("#add-renter-confirm-password").val('');
  $("#add-renter-birthdate").val(''); 
  $("#add-renter-lease-start").val(''); 
}

function clearFieldsModifyRenter() {
  $("#modify-renter-surname").val('');
  $("#modify-renter-first-name").val('');
  $("#modify-renter-middle-name").val('');
  $("#modify-renter-ext-name").val('');
  $("#modify-renter-contact-number").val('');
  $("#modify-renter-valid-id-type").val('Valid ID Type *'); 
  $("#modify-renter-valid-id-number").val('');
  $("#modify-renter-room-number").val('Room Number *'); 
  $("#modify-renter-contract-term").val('');
  $("#modify-renter-birthdate").val('');
  $("#modify-renter-lease-start").val('');
}

function clearFieldsRemoveRenter() {
  $("#remove-renter-reason").val(''); 
  $("#remove-renter-lease-end").val('');
}


// Error message helpers
function showError(msg, boxId, textId) {
  $(boxId).removeClass("d-none").addClass("d-flex");
  $(textId).html(msg);  // <-- convert \n to <br>
  const errorSound = document.getElementById("error-sound");
  if (errorSound) {
    errorSound.currentTime = 0;
    errorSound.play().catch((e) => console.warn("Audio play failed:", e));
  }
}


function hideError(boxId, textId) {
  $(boxId).removeClass("d-flex").addClass("d-none");
  $(textId).text("");
}

// Validation Helpers
function isAfterToday(dateStr) {
  const inputDate = new Date(dateStr);
  const today = new Date();

  // Set time to 00:00:00 for accurate comparison (ignore time part)
  inputDate.setHours(0, 0, 0, 0);
  today.setHours(0, 0, 0, 0);

  return inputDate > today;
}


function isValidPhoneNum(phone) {
  return /^09\d{9}$/.test(phone);
}

function isWhitespaceOnly(value) {
  return /^\s*$/.test(value);
}

function exceedsLengthLimit(value, limit = 1000) {
  return value.length > limit;
}

function isValidEmailFormat(email) {
  const regex = /^(?!.*\.\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return regex.test(email);
}

function isValidEmailChars(email) {
  return /^[a-zA-Z0-9@._]+$/.test(email);
}

function isValidPasswordChars(password) {
  return /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/.test(password);
}

function isNumber(input) {
  return /^[0-9]+$/.test(input);
}

function isValidName(name) {
  if (!name.trim()) return true; // allow empty (optional) fields
  return /^[a-zA-Z\s\-'.]{1,1000}$/.test(name);
}


function isValidIDNumber(id) {
  return /^[a-zA-Z0-9\- ]{1,1000}$/.test(id);
}

function isStrongPassword(password) {
  const errors = [];
  if (password.length < 8) errors.push("Password must be at least 8 characters long.");
  if (!/[A-Z]/.test(password)) errors.push("Password must include at least one uppercase letter.");
  if (!/[a-z]/.test(password)) errors.push("Password must include at least one lowercase letter.");
  if (!/[0-9]/.test(password)) errors.push("Password must include at least one number.");
  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) errors.push("Password must include at least one special character.");
  if (/\s/.test(password)) errors.push("Password must not contain spaces.");

  return { isValid: errors.length === 0, errors };
}

