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
    // Collect values from Add Renter modal
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
  
    // Validation helper
    function showError(msg) {
      $("#error-box").removeClass("d-none").addClass("d-flex");
      $("#error-text").text(msg);
    
      // Play error sound
      const errorSound = document.getElementById("error-sound");
      if (errorSound) {
        errorSound.currentTime = 0; // rewind to start
        errorSound.play().catch((e) => {
          console.warn("Audio play failed:", e);
        });
      }
    }
    

    function hideError() {
      $("#error-box").removeClass("d-flex").addClass("d-none");
      $("#error-text").text("");
    }
    
  
    function validateEmail(email) {
      const regex = /^(?!.*\.\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      return regex.test(email);
    }
  
    let allFilled = true;

    $('[required]').each(function () {
      const tag = $(this).prop("tagName").toLowerCase();
      const type = $(this).attr("type");

      // For all required fields: input, select, etc.
      const value = $(this).val()?.trim();

      if (
        !value ||
        (tag === 'select' && value === "") ||
        (type === 'date' && value === "")
      ) {
        allFilled = false;
        return false; // Break loop on first failure
      }
    });

    if (!allFilled) {
      return showError("All required fields must be filled.");
    }


  
    // Whitespace-only check
    if (/^\s+$/.test(surname) || /^\s+$/.test(firstName) || /^\s+$/.test(contact) || /^\s+$/.test(idNumber) || /^\s+$/.test(email) || /^\s+$/.test(password)) {
      return showError("Whitespace-only fields are not allowed.");
    }
  
    // Length limit
    const fields = [surname, firstName, middleName, extName, contact, idNumber, email, password];
    if (fields.some(f => f.length > 1000)) {
      return showError("One or more fields exceed the length limit.");
    }
  
    // Email and password character validation
    if (/[^a-zA-Z0-9@._]/.test(email)) {
      return showError("Email contains invalid characters.");
    }
    if (/[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      return showError("Password contains invalid characters.");
    }
  
    // Email format check
    if (!validateEmail(email)) {
      return showError("Invalid email format.");
    }
  
    // Password rules
    if (/\s/.test(password)) {
      return showError("Password must not contain spaces.");
    }
    if (password.length < 8) {
      return showError("Password must be at least 8 characters.");
    }
  
    // Fill values in Add Renter Confirmation modal
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
  
    // Show confirmation modal
    $('#modalAddRenter').modal('hide');
    $('#modalAddRenterConfirmation').modal('show');
    hideError();
  });
  
});
  
function updateTime() {
  date = new Date(date.getTime() + 1000);
  const formattedDate = date.toLocaleString("en-US", options);
  $(".current-date").text(formattedDate.replace("at ", ""));
}

