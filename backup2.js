let date = new Date(); // use let to allow updating
const options = {
  year: "numeric",
  month: "long",
  day: "numeric",
  hour: "numeric",
  minute: "2-digit",
  hour12: true,
};

$(document).ready(function () {
  const formattedDate = date.toLocaleString("en-US", options);
  $(".current-date").text(formattedDate.replace("at ", ""));

  const currentYear = new Date().getFullYear();
  $(".current-year").text(currentYear);

  setInterval(updateTime, 1000);

  $('#button-add-renter').on("click", function () {
    console.log("new2 clicked");
  
    // Collect input values
    const surname = $("#add-renter-surname").val().trim();
    const firstName = $("#add-renter-first-name").val().trim();
    const middleName = $("#add-renter-middle-name").val().trim();
    const extName = $("#add-renter-ext-name").val().trim();
    const contact = $("#add-renter-contact-number").val().trim();
    const idType = $("#add-renter-valid-id-type").val();
    const idNumber = $("#add-renter-valid-id-number").val().trim();
    const room = $("#add-renter-room-number").val();
    const contractTerm = $("#add-renter-contract-term").val()?.trim();
    const email = $("#add-renter-email").val().trim();
    const password = $("#add-renter-password").val().trim();
    const birthdate = $("#add-renter-birthdate")?.val();
    const leaseStart = $("#add-renter-lease-start")?.val();
  
    
  
    let allFilled = true;

    $('[required]').each(function () {
      const $el = $(this);
      const tag = $el.prop("tagName").toLowerCase();
      const type = $el.attr("type")?.toLowerCase() || "";

      let value = $el.val();
      if (typeof value === "string") value = value.trim();

      if (
        value === "" ||
        value == null ||
        (tag === "select" && ($el.prop("selectedIndex") === 0 || !value)) ||
        (type === "checkbox" && !$el.is(":checked")) ||
        (type === "radio" && !$(`[name="${$el.attr("name")}"]:checked`).length)
      ) {
        allFilled = false;
        return false; // Exit .each early
      }
    });

    if (!allFilled) return showError("All required fields must be filled.");

  
    // Check for whitespace-only inputs
    if ([surname, firstName, contact, idNumber, email, password].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.");
    }
  
    // Length validation
    if ([surname, firstName, middleName, extName, contact, idNumber, email, password].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.");
    }
  
    // Name validation
    if (![surname, firstName, middleName, extName].every(isValidName)) {
      return showError("One or more names contain invalid characters.");
    }
  
    // Contact number
    if (!isNumber(contact)) {
      return showError("Contact number must be numeric only.");
    }
  
    // ID number validation
    if (!isValidIDNumber(idNumber)) {
      return showError("Invalid characters in ID number.");
    }
  
    // Email validation
    if (!isValidEmailChars(email)) return showError("Email contains invalid characters.");
    if (!isValidEmailFormat(email)) return showError("Invalid email format.");
  
    // Password validation
    if (!isValidPasswordChars(password)) return showError("Password contains invalid characters.");
    const passwordCheck = isStrongPassword(password);
    if (!passwordCheck.isValid) return showError(passwordCheck.errors.join(" "));
  
    // Fill confirmation modal
    $("#confirm-add-renter-first-name").text(firstName);
    $("#confirm-add-renter-middle-name").text(middleName);
    $("#confirm-add-renter-surname").text(surname);
    $("#confirm-add-renter-ext-name").text(extName);
    $("#confirm-add-renter-contact-number").text(contact);
    $("#confirm-add-renter-birthdate").text(birthdate || "-");
    $("#confirm-add-renter-valid-id-type").text(idType ? idType.replace(/-/g, " ").toUpperCase() : "");
    $("#confirm-add-renter-valid-id-number").text(idNumber);
    $("#confirm-add-renter-room-number").text(room);
    $("#confirm-add-renter-contract-term").text(contractTerm || "-");
    $("#confirm-add-renter-lease-start").text(leaseStart || "-");
    $("#confirm-add-renter-email").text(email);
  
    $('#modalAddRenter').modal('hide');
    $('#modalAddRenterConfirmation').modal('show');
    hideError();
  });

  $('button-success-add-renter').on("click", function () {
    clearFields();
    // TODO: save to xml
  });
  
});
  
function updateTime() {
  date = new Date(date.getTime() + 1000);
  const formattedDate = date.toLocaleString("en-US", options);
  $(".current-date").text(formattedDate.replace("at ", ""));
}

function clearFields(){
  $("#add-renter-surname").val('');
  $("#add-renter-first-name").val('');
  $("#add-renter-middle-name").val('');
  $("#add-renter-ext-name").val('');
  $("#add-renter-contact-number").val('');
  $("#add-renter-valid-id-type").val(''); // Assuming this is a select element
  $("#add-renter-valid-id-number").val('');
  $("#add-renter-room-number").val(''); // Assuming this is a select element
  $("#add-renter-contract-term").val(''); // Assuming this is a select element
  $("#add-renter-email").val('');
  $("#add-renter-password").val('');
  $("#add-renter-birthdate").val(''); // Assuming this is a date input
  $("#add-renter-lease-start").val(''); // Assuming this is a date input
}

// Error message helpers
function showError(msg) {
  $("#error-box").removeClass("d-none").addClass("d-flex");
  $("#error-text").text(msg);
  const errorSound = document.getElementById("error-sound");
  if (errorSound) {
    errorSound.currentTime = 0;
    errorSound.play().catch((e) => console.warn("Audio play failed:", e));
  }
}

function hideError() {
  $("#error-box").removeClass("d-flex").addClass("d-none");
  $("#error-text").text("");
}

// Validation Helpers
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