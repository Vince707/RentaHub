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
let roomsDataMap = {};
let utilityBillsMap = {};
let rentBillsMap = {};
let paymentsMap = {};
let tasksMap = {};
let inquiriesMap = {};
let usersMap = {};
let caretakersMap = {};
let auditTrailMap = {};

$.ajax({
  url: 'apartment.xml',
  dataType: 'xml',
  success: function (xml) {

    // --- renters ---
    $(xml).find('renters > renter').each(function () {
      const id = $(this).attr('id').trim();
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

    // --- rooms ---
    $(xml).find('rooms > room').each(function () {
      const id = $(this).attr('id').trim();
      roomsDataMap[id] = {
        roomNo: $(this).find('roomNo').text().trim(),
        floorNo: $(this).find('floorNo').text().trim(),
        roomType: $(this).find('roomType').text().trim(),
        sizeSQM: $(this).find('sizeSQM').text().trim(),
        rentPrice: $(this).find('rentPrice').text().trim(),
        status: $(this).find('status').text().trim(),
        deleteReason: $(this).find('deleteReason').text().trim()
      };
    });

    // --- utilityBills ---
    $(xml).find('billing > utilityBills > utility').each(function () {
      const type = $(this).attr('type');
      let readings = [];
      $(this).find('reading').each(function () {
        let bills = [];
        $(this).find('bill').each(function () {
          bills.push({
            id: $(this).attr('id') || '',
            renterId: $(this).find('renterId').text().trim(),
            currentReading: $(this).find('currentReading').text().trim(),
            consumedKwh: $(this).find('consumedKwh').text().trim() || $(this).find('consumedCubic').text().trim(),
            amount: $(this).find('amount').text().trim(),
            overpaid: $(this).find('overpaid').text().trim(),
            debt: $(this).find('debt').text().trim(),
            status: $(this).find('status').text().trim()
          });
        });

        readings.push({
          id: $(this).attr('id') || '',
          readingDate: $(this).find('readingDate').text().trim(),
          periodEnd: $(this).find('periodEnd').text().trim(),
          dueDate: $(this).find('dueDate').text().trim(),
          consumedKwhTotal: $(this).find('consumedKwhTotal').text().trim() || $(this).find('consumedCubicMTotal').text().trim(),
          amountPerKwh: $(this).find('amountPerKwh').text().trim() || $(this).find('amountPerCubicM').text().trim(),
          totalBill: $(this).find('totalBill').text().trim(),
          status: $(this).find('status').text().trim(),
          bills: bills
        });
      });

      utilityBillsMap[type] = {
        accountName: $(this).find('accountInfo > accountName').text().trim(),
        accountNumber: $(this).find('accountInfo > accountNumber').text().trim(),
        meterNumber: $(this).find('accountInfo > meterNumber').text().trim(),
        address: $(this).find('accountInfo > address').text().trim(),
        readings: readings
      };
    });

    // --- rentBills ---
    $(xml).find('billing > rentBills > bill').each(function () {
      const id = $(this).attr('id').trim();
      rentBillsMap[id] = {
        renterId: $(this).find('renterId').text().trim(),
        amount: $(this).find('amount').text().trim(),
        dueDate: $(this).find('dueDate').text().trim(),
        overpaid: $(this).find('overpaid').text().trim(),
        debt: $(this).find('debt').text().trim(),
        status: $(this).find('status').text().trim()
      };
    });

    // --- payments ---
    $(xml).find('payments > payment').each(function () {
      const id = $(this).attr('id').trim();
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

    // --- tasks ---
    $(xml).find('tasks > task').each(function () {
      const id = $(this).attr('id').trim();
      tasksMap[id] = {
        title: $(this).find('title').text().trim(),
        type: $(this).find('type').text().trim(),
        concernedWith: $(this).find('concernedWith').text().trim(),
        amountPaid: $(this).find('amountPaid').text().trim(),
        dueDate: $(this).find('dueDate').text().trim(),
        status: $(this).find('status').text().trim(),
        deleteReason: $(this).find('deleteReason').text().trim()
      };
    });

    // --- inquiries ---
    $(xml).find('inquiries > inquiry').each(function () {
      const id = $(this).attr('id')?.trim() || ''; // could be empty
      inquiriesMap[id] = {
        renterId: $(this).find('renterId').text().trim(),
        inquiryContent: $(this).find('inquiryContent').text().trim(),
        dateGenerated: $(this).find('dateGenerated').text().trim(),
        status: $(this).find('status').text().trim(),
        response: $(this).find('response').text().trim(),
        deleteReason: $(this).find('deleteReason').text().trim()
      };
    });

    // --- users ---
    $(xml).find('users > user').each(function () {
      const id = $(this).attr('id').trim();
      usersMap[id] = {
        email: $(this).find('email').text().trim(),
        password: $(this).find('password').text().trim(),
        dateGenerated: $(this).find('dateGenerated').text().trim(),
        userRole: $(this).find('userRole').text().trim(),
        status: $(this).find('status').text().trim(),
        lastLogin: $(this).find('lastLogin').text().trim()
      };
    });

    // --- caretakers ---
    $(xml).find('caretakers > caretaker').each(function () {
      const id = $(this).attr('id')?.trim() || ''; // id may be empty
      caretakersMap[id] = {
        userId: $(this).find('userId').text().trim(),
        surname: $(this).find('personalInfo > name > surname').text().trim(),
        firstName: $(this).find('personalInfo > name > firstName').text().trim(),
        middleName: $(this).find('personalInfo > name > middleName').text().trim(),
        extension: $(this).find('personalInfo > name > extension').text().trim()
      };
    });

    // --- auditTrail ---
    $(xml).find('auditTrail > action').each(function () {
      const id = $(this).attr('id')?.trim() || ''; // id may be empty
      auditTrailMap[id] = {
        userId: $(this).find('userId').text().trim(),
        ipAddress: $(this).find('ipAddress').text().trim(),
        concernedModule: $(this).find('concernedModule').text().trim(),
        actionPerformed: $(this).find('actionPerformed').text().trim(),
        timestamp: $(this).find('timestamp').text().trim()
      };
    });

    function calculateTotalUnpaidDebt() {
    let totalDebt = 0;

    // Rent Bills: sum all 'Unpaid' and 'Partial' debts
    Object.values(rentBillsMap).forEach(bill => {
      if (bill.status === 'Unpaid' || bill.status === 'Partial') {
        // Use debt if present, otherwise fallback to amount
        let debt = parseFloat(bill.debt);
        if (isNaN(debt) || debt === 0) {
          debt = parseFloat(bill.amount) || 0;
        }
        totalDebt += debt;
      }
    });

    // Utility Bills: sum all 'Unpaid' and 'Partial' debts
    Object.values(utilityBillsMap).forEach(utility => {
      utility.readings.forEach(reading => {
        reading.bills.forEach(bill => {
          if (bill.status === 'Unpaid' || bill.status === 'Partial') {
            let debt = parseFloat(bill.debt);
            if (isNaN(debt) || debt === 0) {
              debt = parseFloat(bill.amount) || 0;
            }
            totalDebt += debt;
          }
        });
      });
    });

    return totalDebt;
  }

  // Format as PHP currency and update the DOM
  const totalDebt = calculateTotalUnpaidDebt();
  $('#total-unpaid-bill').text(
    Number(totalDebt).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
  );



    const totalCurrentBill = calculateTotalCurrentBill();
    const formatted = totalCurrentBill.toLocaleString("en-PH", {minimumFractionDigits: 2, maximumFractionDigits: 2});
    $('#total-current-bill').text(formatted);

    const overdueTotal = calculateTotalOverdueBills();
    const formattedOverdue = overdueTotal.toLocaleString("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
    $('#overdue-bills-total').text(formattedOverdue);

    const totalElectric = calculateTotalCurrentElectricBill();
    const formattedElectric = totalElectric.toLocaleString("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
    $('#total-current-electric-bill').text(formattedElectric);

    // Water Bill
    const totalWater = calculateTotalCurrentWaterBill();
    const formattedWater = totalWater.toLocaleString("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
    $('#total-current-water-bill').text(formattedWater);

    // Rent Bill
    const totalRent = calculateTotalCurrentRentBill();
    const formattedRent = totalRent.toLocaleString("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
    $('#total-current-rent-bill').text(formattedRent);

    function getMonthNameYear(ym) {
      // ym: 'YYYY-MM'
      const [year, month] = ym.split('-');
      const date = new Date(year, parseInt(month, 10) - 1);
      return date.toLocaleString('default', { month: 'long', year: 'numeric' });
    }

    // Determines badge and color class based on status and amount
    function getBadgeAndClass(status, amount) {
      if (parseFloat(amount) === 0) {
        return {
          badge: '<span class="badge rounded-pill bg-success ms-1">Full Payment</span>',
          cls: 'text-success'
        };
      }
      if (status === "Unpaid") {
        return {
          badge: '<span class="badge rounded-pill bg-danger ms-1">Unpaid</span>',
          cls: 'text-danger'
        };
      }
      if (status === "Partial") {
        return {
          badge: '<span class="badge rounded-pill bg-warning ms-1">Partial Payment</span>',
          cls: 'text-warning'
        };
      }
      if (status === "Paid") {
        return {
          badge: '<span class="badge rounded-pill bg-success ms-1">Full Payment</span>',
          cls: 'text-success'
        };
      }
      return {
        badge: '',
        cls: parseFloat(amount) === 0 ? 'text-success' : 'text-secondary'
      };
    }

    let today = new Date();
    let yearMonth = today.toISOString().slice(0, 7); // 'YYYY-MM'
    let monthDueText = getMonthNameYear(yearMonth);

    let rowsHtml = '';

    Object.keys(renterDataMap).forEach(renterId => {
      const renter = renterDataMap[renterId];
      if (!renter.unitId) return; // Skip if no unit assigned

      const room = roomsDataMap[renter.unitId] || {};
      const roomNo = room.roomNo || '';

      const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

      // --- Electric Bill (current month) ---
      let electricBill = 0, electricStatus = '';
      if (utilityBillsMap['Electricity']) {
        utilityBillsMap['Electricity'].readings.forEach(reading => {
          if (reading.dueDate && reading.dueDate.startsWith(yearMonth)) {
            reading.bills.forEach(bill => {
              if (bill.renterId === renterId) {
                electricBill += parseFloat(bill.amount) || 0;
                electricStatus = bill.status;
              }
            });
          }
        });
      }
      let electricInfo = getBadgeAndClass(electricStatus, electricBill);

      // --- Water Bill (current month) ---
      let waterBill = 0, waterStatus = '';
      if (utilityBillsMap['Water']) {
        utilityBillsMap['Water'].readings.forEach(reading => {
          if (reading.dueDate && reading.dueDate.startsWith(yearMonth)) {
            reading.bills.forEach(bill => {
              if (bill.renterId === renterId) {
                waterBill += parseFloat(bill.amount) || 0;
                waterStatus = bill.status;
              }
            });
          }
        });
      }
      let waterInfo = getBadgeAndClass(waterStatus, waterBill);

      // --- Rent Bill (current month) ---
      let rentBill = 0, rentStatus = '';
      Object.values(rentBillsMap).forEach(bill => {
        if (bill.renterId === renterId && bill.dueDate && bill.dueDate.startsWith(yearMonth)) {
          rentBill += parseFloat(bill.amount) || 0;
          rentStatus = bill.status;
        }
      });
      let rentInfo = getBadgeAndClass(rentStatus, rentBill);

      // --- Overdue: all unpaid bills with dueDate < today ---
      let overdue = 0, overdueStatus = '';
      Object.values(rentBillsMap).forEach(bill => {
        if (bill.renterId === renterId && bill.status === 'Unpaid' && bill.dueDate && new Date(bill.dueDate) < today) {
          overdue += parseFloat(bill.amount) || 0;
          overdueStatus = bill.status;
        }
      });
      ['Electricity', 'Water'].forEach(type => {
        if (utilityBillsMap[type]) {
          utilityBillsMap[type].readings.forEach(reading => {
            if (reading.dueDate && new Date(reading.dueDate) < today) {
              reading.bills.forEach(bill => {
                if (bill.renterId === renterId && bill.status === 'Unpaid') {
                  overdue += parseFloat(bill.amount) || 0;
                  overdueStatus = bill.status;
                }
              });
            }
          });
        }
      });
      let overdueInfo = getBadgeAndClass(overdueStatus, overdue);

      // --- Total (current month) ---
      let total = electricBill + waterBill + rentBill + overdue;
      let totalStatus = (electricStatus === 'Unpaid' || waterStatus === 'Unpaid' || rentStatus === 'Unpaid') ? 'Unpaid'
        : (electricStatus === 'Partial' || waterStatus === 'Partial' || rentStatus === 'Partial') ? 'Partial'
        : 'Paid';
      let totalInfo = getBadgeAndClass(totalStatus, total);

      // --- Total Unpaid: all unpaid bills for this renter ---
      let totalUnpaid = 0, unpaidStatus = '';

      // Rent Bills
      Object.values(rentBillsMap).forEach(bill => {
        if (bill.renterId === renterId) {
          if (bill.status === 'Unpaid') {
            totalUnpaid += parseFloat(bill.amount) || 0;
            unpaidStatus = bill.status;
          } else if (bill.status === 'Partial') {
            totalUnpaid += parseFloat(bill.debt) || 0;
            unpaidStatus = bill.status;
          }
        }
      });

      // Utility Bills (Electricity & Water)
      ['Electricity', 'Water'].forEach(type => {
        if (utilityBillsMap[type]) {
          utilityBillsMap[type].readings.forEach(reading => {
            reading.bills.forEach(bill => {
              if (bill.renterId === renterId) {
                if (bill.status === 'Unpaid') {
                  totalUnpaid += parseFloat(bill.amount) || 0;
                  unpaidStatus = bill.status;
                } else if (bill.status === 'Partial') {
                  totalUnpaid += parseFloat(bill.debt) || 0;
                  unpaidStatus = bill.status;
                }
              }
            });
          });
        }
      });

      let unpaidInfo = getBadgeAndClass(unpaidStatus, totalUnpaid);

      rowsHtml += `
        <tr>
          <td>${roomNo}</td>
          <td>${fullName}</td>
          <td>${monthDueText}</td>
          <td class="${electricInfo.cls}">${formatPHP(electricBill)}${electricInfo.badge}</td>
          <td class="${waterInfo.cls}">${formatPHP(waterBill)}${waterInfo.badge}</td>
          <td class="${rentInfo.cls}">${formatPHP(rentBill)}${rentInfo.badge}</td>
          <td class="${overdueInfo.cls}">${formatPHP(overdue)}${overdueInfo.badge}</td>
          <td class="${totalInfo.cls}">${formatPHP(total)}${totalInfo.badge}</td>
          <td class="${unpaidInfo.cls}">${formatPHP(totalUnpaid)}${unpaidInfo.badge}</td>
        </tr>
      `;
    });

    $('#billings-summary tbody').html(rowsHtml);


    function formatPHP(amount) {
      return Number(amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function updateIndividualMetrics(renterId, selectedMonth) {
      let totalUnpaid = 0;
      let currentBill = 0;
      let currentPaid = 0;
      let overpaid = 0;

      // Rent Bills
      Object.values(rentBillsMap).forEach(bill => {
        if (bill.renterId === renterId) {
          // Total Unpaid: sum debts for Unpaid/Partial, else 0
          if (bill.status === 'Unpaid' || bill.status === 'Partial') {
            totalUnpaid += parseFloat(bill.debt || bill.amount) || 0;
          }
          // Current Bill: for selected month
          if (bill.dueDate && bill.dueDate.startsWith(selectedMonth)) {
            currentBill += parseFloat(bill.amount) || 0;
            if (bill.status === 'Paid') currentPaid += parseFloat(bill.amount) || 0;
            if (parseFloat(bill.overpaid) > 0) overpaid += parseFloat(bill.overpaid) || 0;
          }
        }
      });

      // Utility Bills
      Object.values(utilityBillsMap).forEach(utility => {
        utility.readings.forEach(reading => {
          reading.bills.forEach(bill => {
            if (bill.renterId === renterId) {
              // Total Unpaid: sum debts for Unpaid/Partial, else 0
              if (bill.status === 'Unpaid' || bill.status === 'Partial') {
                totalUnpaid += parseFloat(bill.debt || bill.amount) || 0;
              }
              // Current Bill: for selected month
              if (reading.dueDate && reading.dueDate.startsWith(selectedMonth)) {
                currentBill += parseFloat(bill.amount) || 0;
                if (bill.status === 'Paid') currentPaid += parseFloat(bill.amount) || 0;
                if (parseFloat(bill.overpaid) > 0) overpaid += parseFloat(bill.overpaid) || 0;
              }
            }
          });
        });
      });

      // Update the UI
      $('#individual-total-unpaid').text(formatPHP(totalUnpaid));
      $('#individual-current-bill').text(formatPHP(currentBill));
      $('#individual-current-paid').text(formatPHP(currentPaid));
      $('#individual-overpaid').text(formatPHP(overpaid));
    }

    // When either select changes, update metrics
    $('#select-billings-renter, #individual-month-due').on('change input', function() {
      const renterId = $('#select-billings-renter').val();
      const selectedMonth = $('#individual-month-due').val(); // Format: "YYYY-MM"
      if (renterId && selectedMonth) {
        updateIndividualMetrics(renterId, selectedMonth);
      } else {
        // Reset metrics if not fully selected
        $('#individual-total-unpaid, #individual-current-bill, #individual-current-paid, #individual-overpaid')
          .text('0.00');
      }
    });

    function getPreviousElectricReading(renterId, selectedMonth) {
      const electricUtility = utilityBillsMap['Electricity'];
      if (!electricUtility) return '';

      // Sort readings by dueDate ascending
      const readings = electricUtility.readings
        .filter(r => r.dueDate)
        .sort((a, b) => a.dueDate.localeCompare(b.dueDate));

      // Find the index of the current reading for the selected month
      const currentIndex = readings.findIndex(r => r.dueDate.startsWith(selectedMonth));
      if (currentIndex === -1) return '';

      // Find the previous reading (if any)
      for (let i = currentIndex - 1; i >= 0; i--) {
        // Find the bill for this renter in the previous reading
        const prevBill = readings[i].bills.find(b => b.renterId === renterId);
        if (prevBill && prevBill.currentReading) {
          return prevBill.currentReading;
        }
      }
      return '';
    }

    function updateElectricBillCard(bill, reading, renterId) {
  // Remove any existing Pay or Paid button
  $('.electric-pay-button .pay-btn, .electric-pay-button .paid-btn').remove();

  // Get the card container
  const $card = $('.electric-bill-card .gradient-red-bg, .electric-bill-card .gradient-green-bg');

  if (bill && bill.status !== 'Paid') {
    // Ensure card is red
    $card.removeClass('gradient-green-bg').addClass('gradient-red-bg');

    // Add Pay button
    $('.electric-pay-button').append(
      `<button type="button"
              class="btn-white pay-btn d-flex align-items-center px-3 py-1"
              data-type="Electric"
              data-bill-id="${bill.id}"
              data-reading-id="${reading.id}"
              data-renter-id="${renterId}"
              data-bs-toggle="modal"
              data-bs-target="#modalRecordPayment">
        Pay
      </button>`
    );
  } else {
    // Ensure card is green
    $card.removeClass('gradient-red-bg').addClass('gradient-green-bg');

    // Add Paid badge
    $('.electric-pay-button').append(
      `<div class="d-flex align-items-center px-3 py-1 paid-btn" style="color: #FFFFFF;
        font-size: 1.1rem;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: background-color 0.3s, color 0.3s;">
        Paid
      </div>`
    );
  }
}



    function populateElectricBillCard(renterId, selectedMonth) {
      const electricUtility = utilityBillsMap['Electricity'];
      if (!electricUtility) {
        // Clear fields if not found
        $('#electric-reading-date, #electric-due-date, #electric-current-reading, #electric-previous-reading, #electric-consumed-kwh, #electric-amount-per-kwh, #electric-your-bill').text('');
        return;
      }

      // Find the reading for the selected month
      const reading = electricUtility.readings.find(r => r.dueDate && r.dueDate.startsWith(selectedMonth));
      if (!reading) {
        $('#electric-reading-date, #electric-due-date, #electric-current-reading, #electric-previous-reading, #electric-consumed-kwh, #electric-amount-per-kwh, #electric-your-bill').text('');
        return;
      }

      // Find the bill for this renter
      const bill = reading.bills.find(b => b.renterId === renterId);
      if (!bill) {
        $('#electric-reading-date, #electric-due-date, #electric-current-reading, #electric-previous-reading, #electric-consumed-kwh, #electric-amount-per-kwh, #electric-your-bill').text('');
        return;
      }

   updateElectricBillCard(bill, reading, renterId);


      // Get previous reading
      const previousReading = getPreviousElectricReading(renterId, selectedMonth);

      $('#electric-reading-date').text(reading.readingDate || '');
      $('#electric-due-date').text(reading.dueDate || '');
      $('#electric-current-reading').text(bill.currentReading || '');
      $('#electric-previous-reading').text(previousReading || '');
      $('#electric-consumed-kwh').text(bill.consumedKwh || reading.consumedKwhTotal || '');
      $('#electric-amount-per-kwh').text(reading.amountPerKwh || '');
      $('#electric-your-bill').text('PHP ' + Number(bill.amount || 0).toLocaleString('en-PH', {minimumFractionDigits:2}));
    }

    
    $('#select-billings-renter, #individual-month-due').on('change input', function() {
      const $electricCard = $('.electric-bill-card .gradient-red-bg, .electric-bill-card .gradient-green-bg');
      $electricCard.removeClass('gradient-green-bg').addClass('gradient-red-bg');
      const $waterCard = $('.water-bill-card .gradient-red-bg, .water-bill-card .gradient-green-bg');
      $waterCard.removeClass('gradient-green-bg').addClass('gradient-red-bg');
      const $rentCard = $('.rent-bill-card .gradient-red-bg, .rent-bill-card .gradient-green-bg');
      $rentCard.removeClass('gradient-green-bg').addClass('gradient-red-bg');
      const $overdueCard = $('.overdue-bill-card .gradient-red-bg, .overdue-bill-card .gradient-green-bg');
      $overdueCard.removeClass('gradient-green-bg').addClass('gradient-red-bg');
      
      const renterId = $('#select-billings-renter').val();
      const selectedMonth = $('#individual-month-due').val(); // Format: "YYYY-MM"
      if (renterId && selectedMonth) {
        populateElectricBillCard(renterId, selectedMonth);
      } else {
        $('#electric-reading-date, #electric-due-date, #electric-current-reading, #electric-previous-reading, #electric-consumed-kwh, #electric-amount-per-kwh, #electric-your-bill').text('');
      }
    });

    function getPreviousWaterReading(renterId, selectedMonth) {
  const waterUtility = utilityBillsMap['Water'];
  if (!waterUtility) return '';

  // Sort readings by dueDate ascending
  const readings = waterUtility.readings
    .filter(r => r.dueDate)
    .sort((a, b) => a.dueDate.localeCompare(b.dueDate));

  // Find the index of the current reading for the selected month
  const currentIndex = readings.findIndex(r => r.dueDate.startsWith(selectedMonth));
  if (currentIndex === -1) return '';

  // Find the previous reading (if any)
  for (let i = currentIndex - 1; i >= 0; i--) {
    // Find the bill for this renter in the previous reading
    const prevBill = readings[i].bills.find(b => b.renterId === renterId);
    if (prevBill && prevBill.currentReading) {
      return prevBill.currentReading;
    }
  }
  return '';
}

function updateWaterBillCard(bill, reading, renterId) {
  // Remove any existing Pay or Paid button
  $('.water-pay-button .pay-btn, .water-pay-button .paid-btn').remove();

  // Get the card container
  const $card = $('.water-bill-card .gradient-red-bg, .water-bill-card .gradient-green-bg');

  if (bill && bill.status !== 'Paid') {
    // Ensure card is red
    $card.removeClass('gradient-green-bg').addClass('gradient-red-bg');

    // Add Pay button
    $('.water-pay-button').append(
      `<button type="button"
              class="btn-white pay-btn d-flex align-items-center px-3 py-1"
              data-type="Water"
              data-bill-id="${bill.id}"
              data-reading-id="${reading.id}"
              data-renter-id="${renterId}"
              data-bs-toggle="modal"
              data-bs-target="#modalRecordPayment">
        Pay
      </button>`
    );
  } else {
    // Ensure card is green
    $card.removeClass('gradient-red-bg').addClass('gradient-green-bg');

    // Add Paid badge
    $('.water-pay-button').append(
      `<div class="d-flex align-items-center px-3 py-1 paid-btn" style="color: #FFFFFF;
        font-size: 1.1rem;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: background-color 0.3s, color 0.3s;">
        Paid
      </div>`
    );
  }
}


function populateWaterBillCard(renterId, selectedMonth) {
  const waterUtility = utilityBillsMap['Water'];
  if (!waterUtility) {
    $('#water-reading-date, #water-due-date, #water-current-reading, #water-previous-reading, #water-consumed-cubic, #water-amount-per-cubic, #water-your-bill').text('');
    return;
  }

  // Find the reading for the selected month
  const reading = waterUtility.readings.find(r => r.dueDate && r.dueDate.startsWith(selectedMonth));
  if (!reading) {
    $('#water-reading-date, #water-due-date, #water-current-reading, #water-previous-reading, #water-consumed-cubic, #water-amount-per-cubic, #water-your-bill').text('');
    return;
  }

  // Find the bill for this renter
  const bill = reading.bills.find(b => b.renterId === renterId);
  if (!bill) {
    $('#water-reading-date, #water-due-date, #water-current-reading, #water-previous-reading, #water-consumed-cubic, #water-amount-per-cubic, #water-your-bill').text('');
    return;
  }

    updateWaterBillCard(bill, reading, renterId);

  // Get previous reading
  const previousReading = getPreviousWaterReading(renterId, selectedMonth);

  $('#water-reading-date').text(reading.readingDate || '');
  $('#water-due-date').text(reading.dueDate || '');
  $('#water-current-reading').text(bill.currentReading || '');
  $('#water-previous-reading').text(previousReading || '');
  $('#water-consumed-cubic').text(bill.consumedKwh || reading.consumedKwhTotal || ''); // for water, this is cubic meters
  $('#water-amount-per-cubic').text(reading.amountPerKwh || ''); // for water, this is amountPerCubicM
  $('#water-your-bill').text('PHP ' + Number(bill.amount || 0).toLocaleString('en-PH', {minimumFractionDigits:2}));
}

$('#select-billings-renter, #individual-month-due').on('change input', function() {
  const renterId = $('#select-billings-renter').val();
  const selectedMonth = $('#individual-month-due').val(); // Format: "YYYY-MM"
  if (renterId && selectedMonth) {
    populateWaterBillCard(renterId, selectedMonth);
  } else {
    $('#water-reading-date, #water-due-date, #water-current-reading, #water-previous-reading, #water-consumed-cubic, #water-amount-per-cubic, #water-your-bill').text('');
  }
});

function updateRentBillCard(bill, renterId) {
  const key = Object.keys(rentBillsMap).find(k => rentBillsMap[k] === bill);

  // Remove any existing Pay or Paid button
  $('.rent-pay-button .pay-btn, .rent-pay-button .paid-btn').remove();

  // Get the card container (red or green)
  const $card = $('.rent-bill-card .gradient-red-bg, .rent-bill-card .gradient-green-bg');

  if (bill && bill.status !== 'Paid') {
    // Ensure card is red
    $card.removeClass('gradient-green-bg').addClass('gradient-red-bg');

    // Add Pay button
    $('.rent-pay-button').append(
      `<button type="button"
              class="btn-white pay-btn d-flex align-items-center px-3 py-1"
              data-type="Rent"
              data-bill-id="${key}"
              data-renter-id="${renterId}"
              data-bs-toggle="modal"
              data-bs-target="#modalRecordPayment">
        Pay
      </button>`
    );
  } else {
    // Ensure card is green
    $card.removeClass('gradient-red-bg').addClass('gradient-green-bg');

    // Add Paid badge
    $('.rent-pay-button').append(
      `<div class="d-flex align-items-center px-3 py-1 paid-btn" style="color: #FFFFFF;
        font-size: 1.1rem;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: background-color 0.3s, color 0.3s;">
        Paid
      </div>`
    );
  }
}

function populateRentCard(renterId, selectedMonth) {
  // Find the rent bill for this renter and month
  const rentBill = Object.values(rentBillsMap).find(bill =>
    bill.renterId === renterId && bill.dueDate && bill.dueDate.startsWith(selectedMonth)
  );

  if (!rentBill) {
    $('#rent-start-due-date, #rent-end-date, #rent-your-bill').text('');
    updateRentBillCard(null, renterId);
    return;
  }


  // Get the renter's lease info for start/end
  const renter = Object.values(renterDataMap).find(r => r.userId === renterId);
  let leaseStart = renter?.leaseStart || '';
  let leaseEnd = renter?.leaseEnd || '';

  // Format dates
  let dueDate = rentBill.dueDate || '';
  let startDueDate = leaseStart ? `${leaseStart} to ${dueDate}` : dueDate;

  // Update the rent card's button and background
  updateRentBillCard(rentBill, renterId);

  // Update rent card info
  $('#rent-start-due-date').text(startDueDate);
  $('#rent-end-date').text(leaseEnd);
  $('#rent-your-bill').text('PHP ' + Number(rentBill.amount || 0).toLocaleString('en-PH', {minimumFractionDigits:2}));
}


$('#select-billings-renter, #individual-month-due').on('change input', function() {
  const renterId = $('#select-billings-renter').val();
  const selectedMonth = $('#individual-month-due').val(); // Format: "YYYY-MM"
  if (renterId && selectedMonth) {
    populateRentCard(renterId, selectedMonth);
  } else {
    $('#rent-start-due-date, #rent-end-date, #rent-your-bill').text('');
  }
});

function updateOverdueBillCard(overdueBills, renterId) {
  // Remove any existing Pay or Paid button
  $('.overdue-pay-button .pay-btn, .overdue-pay-button .paid-btn').remove();

  // Get the card container
  const $card = $('.overdue-bill-card .gradient-red-bg, .overdue-bill-card .gradient-green-bg');

  // Determine if there are any unpaid/partial bills
  const hasOverdue = overdueBills && overdueBills.length > 0;

  if (hasOverdue) {
    // Ensure card is red
    $card.removeClass('gradient-green-bg').addClass('gradient-red-bg');

    // Prepare a data attribute with all bill keys (IDs) for modal use
    const billIds = overdueBills.map(bill => bill.id).join(',');
    console.log("OTHER: " + billIds);

    // Add Pay button (could be for all overdue bills at once)
    $('.overdue-pay-button').append(
      `<button type="button"
              class="btn-white pay-btn d-flex align-items-center px-3 py-1"
              data-type="Overdue"
              data-bill-ids="${billIds}"
              data-renter-id="${renterId}"
              data-bs-toggle="modal"
              data-bs-target="#modalRecordPayment">
        Pay All Overdue
      </button>`
    );
  } else {
    // Ensure card is green
    $card.removeClass('gradient-red-bg').addClass('gradient-green-bg');

    // Add Paid badge
    $('.overdue-pay-button').append(
      `<div class="d-flex align-items-center px-3 py-1 paid-btn" style="color: #FFFFFF;
        font-size: 1.1rem;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: background-color 0.3s, color 0.3s;">
        No Overdue
      </div>`
    );
  }
}

function getOverdueBillsForRenter(renterId) {
  let overdueBills = [];

  // Electric
  Object.values(utilityBillsMap['Electricity']?.readings || []).forEach(reading => {
    (reading.bills || []).forEach(bill => {
      if (bill.renterId === renterId && bill.status !== 'Paid') {
        overdueBills.push({ ...bill, type: 'Electric', readingId: reading.id });
      }
    });
  });

  // Water
  Object.values(utilityBillsMap['Water']?.readings || []).forEach(reading => {
    (reading.bills || []).forEach(bill => {
      if (bill.renterId === renterId && bill.status !== 'Paid') {
        overdueBills.push({ ...bill, type: 'Water', readingId: reading.id });
      }
    });
  });

  // Rent
  Object.values(rentBillsMap || {}).forEach(bill => {
    if (bill.renterId === renterId && bill.status !== 'Paid') {
      overdueBills.push({ ...bill, type: 'Rent' });
    }
  });

  return overdueBills;
}



function populateOverdueBillsCard(renterId) {
  let today = new Date();
  let electricOverdue = 0, waterOverdue = 0, rentOverdue = 0;
  let electricDueDate = '', waterDueDate = '', rentDueDate = '';

  // --- Electric Overdue ---
  if (utilityBillsMap['Electricity']) {
    utilityBillsMap['Electricity'].readings.forEach(reading => {
      if (reading.dueDate && new Date(reading.dueDate) < today) {
        reading.bills.forEach(bill => {
          if (bill.renterId === renterId && (bill.status === 'Unpaid' || bill.status === 'Partial')) {
            electricOverdue += parseFloat(bill.debt || bill.amount) || 0;
            electricDueDate = reading.dueDate; // Use the latest found
          }
        });
      }
    });
  }

  // --- Water Overdue ---
  if (utilityBillsMap['Water']) {
    utilityBillsMap['Water'].readings.forEach(reading => {
      if (reading.dueDate && new Date(reading.dueDate) < today) {
        reading.bills.forEach(bill => {
          if (bill.renterId === renterId && (bill.status === 'Unpaid' || bill.status === 'Partial')) {
            waterOverdue += parseFloat(bill.debt || bill.amount) || 0;
            waterDueDate = reading.dueDate;
          }
        });
      }
    });
  }

  // --- Rent Overdue ---
  Object.values(rentBillsMap).forEach(bill => {
    if (bill.renterId === renterId && bill.dueDate && new Date(bill.dueDate) < today &&
        (bill.status === 'Unpaid' || bill.status === 'Partial')) {
      rentOverdue += parseFloat(bill.debt || bill.amount) || 0;
      rentDueDate = bill.dueDate;
    }
  });

  const overdueBills = getOverdueBillsForRenter(renterId);
  updateOverdueBillCard(overdueBills, renterId);


  // --- Update the UI ---
  $('#overdue-electric').text('PHP ' + Number(electricOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));
  $('#overdue-water').text('PHP ' + Number(waterOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));
  $('#overdue-rent').text('PHP ' + Number(rentOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));

  // Electric Due Date
  if (electricOverdue > 0 && electricDueDate) {
    $('#overdue-electric-due-date').text(electricDueDate);
    $('#overdue-electric-due-date-container').show();
  } else {
    $('#overdue-electric-due-date').text('');
    $('#overdue-electric-due-date-container').hide();
  }

  // Water Due Date
  if (waterOverdue > 0 && waterDueDate) {
    $('#overdue-water-due-date').text(waterDueDate);
    $('#overdue-water-due-date-container').show();
  } else {
    $('#overdue-water-due-date').text('');
    $('#overdue-water-due-date-container').hide();
  }

  // Rent Due Date
  if (rentOverdue > 0 && rentDueDate) {
    $('#overdue-rent-due-date').text(rentDueDate);
    $('#overdue-rent-due-date-container').show();
  } else {
    $('#overdue-rent-due-date').text('');
    $('#overdue-rent-due-date-container').hide();
  }
}

$('#select-billings-renter, #individual-month-due').on('change input', function() {
  const renterId = $('#select-billings-renter').val();
  if (renterId) {
    populateOverdueBillsCard(renterId);
  } else {
    $('#overdue-electric, #overdue-water, #overdue-rent').text('');
    $('#overdue-electric-due-date-container, #overdue-water-due-date-container, #overdue-rent-due-date-container').hide();
  }
});

function getNextReceiptNumber() {
  // Get all IDs from paymentsMap
  const ids = Object.keys(paymentsMap)
    .filter(id => /^R\d+$/.test(id)); // Only IDs like R25000001

  if (ids.length === 0) return "R25000001"; // First receipt

  // Find the max numeric part
  const maxNum = Math.max(...ids.map(id => parseInt(id.replace(/^R/, ''), 10)));
  const nextNum = maxNum + 1;
  // Pad with zeros to keep the same length (8 digits after R)
  return "R" + String(nextNum).padStart(8, '0');
}

let selectedBillId = null;          // e.g., "E1" or "W3" or "101"
let selectedReadingId = null;       // e.g., "1" (reading id for utilities)
let overdueBillIdsArray = [];       // e.g., ["E1", "W1", "101"]
let isOverduePayment = false;       // true if paying multiple bills (overdue)

$(document).on('click', '.pay-btn', function() {
  const type = $(this).attr('data-type');
  const billId = $(this).attr('data-bill-id');
  const readingId = $(this).attr('data-reading-id');
  const renterId = $(this).attr('data-renter-id');

  let bill = null;
  let reading = null;
  let billsToPay = [];

  if (type === 'Electric' && utilityBillsMap['Electricity']) {
    reading = utilityBillsMap['Electricity'].readings.find(r => r.id == readingId);
    if (reading) bill = reading.bills.find(b => b.id == billId);

  } else if (type === 'Water' && utilityBillsMap['Water']) {
    reading = utilityBillsMap['Water'].readings.find(r => r.id == readingId);
    if (reading) bill = reading.bills.find(b => b.id == billId);

  } else if (type === 'Rent') {
    bill = rentBillsMap[billId];

  } else if (type === 'Overdue') {
    const billIdsStr = $(this).attr('data-bill-ids') || '';
    const billIds = billIdsStr.split(',').map(id => id.trim()).filter(id => id);

    billIds.forEach(id => {
      let foundBill = null;
      // Electric
      if (!foundBill && utilityBillsMap['Electricity']) {
        for (const reading of utilityBillsMap['Electricity'].readings) {
          if (Array.isArray(reading.bills)) {
            foundBill = reading.bills.find(b => b.id === id);
          } else if (reading.bill) {
            const billsArr = Array.isArray(reading.bill) ? reading.bill : [reading.bill];
            foundBill = billsArr.find(b => b.id === id);
          }
          if (foundBill) break;
        }
      }
      // Water
      if (!foundBill && utilityBillsMap['Water']) {
        for (const reading of utilityBillsMap['Water'].readings) {
          if (Array.isArray(reading.bills)) {
            foundBill = reading.bills.find(b => b.id === id);
          } else if (reading.bill) {
            const billsArr = Array.isArray(reading.bill) ? reading.bill : [reading.bill];
            foundBill = billsArr.find(b => b.id === id);
          }
          if (foundBill) break;
        }
      }
      // Rent
      if (!foundBill && rentBillsMap[id]) {
        foundBill = rentBillsMap[id];
      }
      if (foundBill) billsToPay.push(foundBill);
    });

    if (billsToPay.length === 0) {
      alert("No overdue bills found. Please check the data attributes.");
      return;
    }
  }

  // If not overdue type, check if bill found
  if (type !== 'Overdue' && !bill) {
    alert("Bill not found. Please check the data attributes.");
    return;
  }

  // === SET YOUR GLOBAL VARIABLES HERE ===
  if (type === 'Overdue') {
    isOverduePayment = true;
    overdueBillIdsArray = billsToPay.map(b => b.id);
    selectedBillId = null;
    selectedReadingId = null;
  } else {
    isOverduePayment = false;
    selectedBillId = billId || null;
    selectedReadingId = readingId || null;
    overdueBillIdsArray = [];
  }

  // Set modal fields
  $('#record-payment-renter').val(renterId);

  // --- CHECKBOX LOGIC ---
  if (type === 'Overdue') {
    $('#record-payment-electric-checkbox').prop('checked', false);
    $('#record-payment-water-checkbox').prop('checked', false);
    $('#record-payment-rent-checkbox').prop('checked', false);

    const typesPresent = new Set(billsToPay.map(b => b.type || 
      (b.id && b.id.startsWith('E') ? 'Electric' : 
       b.id && b.id.startsWith('W') ? 'Water' : 
       b.id && b.id.startsWith('R') ? 'Rent' : null)
    ));
    if (typesPresent.has('Electric')) $('#record-payment-electric-checkbox').prop('checked', true);
    if (typesPresent.has('Water')) $('#record-payment-water-checkbox').prop('checked', true);
    if (typesPresent.has('Rent')) $('#record-payment-rent-checkbox').prop('checked', true);
  } else {
    $('#record-payment-electric-checkbox').prop('checked', type === 'Electric');
    $('#record-payment-water-checkbox').prop('checked', type === 'Water');
    $('#record-payment-rent-checkbox').prop('checked', type === 'Rent');
  }

  // --- AMOUNT LOGIC ---
  let amount = 0;
  if (type === 'Overdue') {
    amount = billsToPay.reduce((sum, b) => {
      if (b.status === 'Partial') {
        return sum + Number(b.debt || b.amount || 0);
      }
      return sum + Number(b.amount || 0);
    }, 0);
  } else {
    if (bill.status === 'Partial') {
      amount = Number(bill.debt);
    } else {
      amount = Number(bill.amount);
    }
  }

  $('#record-payment-payment-amount').val(amount);

  $('#record-payment-payment-date').val(formatDateToYYYYMMDD(new Date()));
  $('#record-payment-receipt-number').text(getNextReceiptNumber());

  $('#modalRecordPayment').modal('show');
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

  const loginAction = urlParams.get('login');
  switch (loginAction) {
    case 'changePassSuccess':
      $('#login-div').addClass("d-none");
      $('#success-change-pass-div').removeClass("d-none").addClass("d-block");
      break;

    default:
      // Do nothing or handle unknown action
      break;
  }

  // NEW: Check for payment success
  const payStatus = urlParams.get('pay');
  if (payStatus === 'recorded') {
    $('#modalRecordPaymentSuccess').modal('show');
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
  
function getNextReceiptNumber() {
  // Get all IDs from paymentsMap
  const ids = Object.keys(paymentsMap)
    .filter(id => /^R\d+$/.test(id)); // Only IDs like R25000001

  if (ids.length === 0) return "R25000001"; // First receipt

  // Find the max numeric part
  const maxNum = Math.max(...ids.map(id => parseInt(id.replace(/^R/, ''), 10)));
  const nextNum = maxNum + 1;
  // Pad with zeros to keep the same length (8 digits after R)
  return "R" + String(nextNum).padStart(8, '0');
}

let selectedBillId = null;          // e.g., "E1" or "W3" or "101"
let selectedReadingId = null;       // e.g., "1" (reading id for utilities)
let overdueBillIdsArray = [];       // e.g., ["E1", "W1", "101"]
let isOverduePayment = false;       // true if paying multiple bills (overdue)

  // Main handler for record payment button
$('#button-record-payment').on("click", function () {
    // Collect input values
    const receiptID = getNextReceiptNumber();
    const renterId = $("#record-payment-renter").val();
    const paymentTypes = [];
    if ($("#record-payment-electric-checkbox").is(":checked")) paymentTypes.push("Electric");
    if ($("#record-payment-water-checkbox").is(":checked")) paymentTypes.push("Water");
    if ($("#record-payment-rent-checkbox").is(":checked")) paymentTypes.push("Rent");

    const paymentDate = $("#record-payment-payment-date").val().trim();
    const paymentAmount = $("#record-payment-payment-amount").val().trim();
    const paymentMethod = $("#record-payment-method").val(); 
    const paymentAmountType = $("#record-payment-amount-type").val();
    const remarks = $("#record-payment-remarks").val().trim();

    // VALIDATIONS
    if (!renterId || !paymentTypes.length || !paymentDate || !paymentAmount || !paymentMethod || !paymentAmountType) {
      return showError("All required fields must be filled.", "#error-box-record-payment", "#error-text-record-payment");
    }    

    if ([renterId, paymentTypes, paymentDate, paymentAmount, paymentMethod, paymentAmountType].some(isWhitespaceOnly)) {
      return showError("Whitespace-only fields are not allowed.", "#error-box-record-payment", "#error-text-record-payment");
    }
    if ([renterId, paymentTypes, paymentDate, paymentAmount, paymentMethod, paymentAmountType, remarks].some(f => exceedsLengthLimit(f))) {
      return showError("One or more fields exceed the length limit.", "#error-box-record-payment", "#error-text-record-payment");
    }
    if (!isNumber(paymentAmount)) {
      return showError("Payment amount must be numeric only.", "#error-box-record-payment", "#error-text-record-payment");
    }

    // Fill confirmation modal
    $("#confirm-record-receipt-number").text(receiptID);
    $("#confirm-record-renter-id").text(renterId);
    $("#confirm-record-payment-type").text(paymentTypes.join(", "));
    $("#confirm-record-payment-date").text(paymentDate);
    $("#confirm-record-payment-amount").text(paymentAmount);
    $("#confirm-record-payment-method").text(paymentMethod);
    $("#confirm-record-payment-amount-type").text(paymentAmountType);
    $("#confirm-record-payment-remarks").text(remarks);

    // FILL Hidden form for PHP (for payment confirmation)
    $("#hidden-record-receipt-number").val(receiptID);
    $("#hidden-record-renter-id").val(renterId);
    $("#hidden-record-payment-type").val(paymentTypes.join(", "));
    $("#hidden-record-payment-date").val(paymentDate);
    $("#hidden-record-payment-amount").val(paymentAmount);
    $("#hidden-record-payment-method").val(paymentMethod);
    $("#hidden-record-payment-amount-type").val(paymentAmountType);
    $("#hidden-record-payment-remarks").val(remarks);

    // Set bill_id, reading_id, overdue_bill_ids
    if (isOverduePayment) {
        $("#hidden-record-bill-id").val("");
        $("#hidden-record-reading-id").val("");
        $("#hidden-record-overdue-bill-ids").val(overdueBillIdsArray.join(","));
    } else {
        $("#hidden-record-bill-id").val(selectedBillId || "");
        $("#hidden-record-reading-id").val(selectedReadingId || "");
        $("#hidden-record-overdue-bill-ids").val("");
    }

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

$(document).on("click", ".button-table-view-renter", function () {
  const renterId = $(this).data('renter-id');
  const renter = renterDataMap[renterId];

  if (renter) {
    const unitId = renter.unitId.trim(); // ensure trimming
    const room = roomsDataMap[unitId];
    const roomNo = room ? room.roomNo : "N/A";
    const userId = renter.userId.trim(); // ensure trimming
    const user = usersMap[userId];
    const email = user ? user.email : "N/A";



    // Set display values
    $('#view-add-renter-surname').text(renter.surname);
    $('#view-add-renter-first-name').text(renter.firstName);
    $('#view-add-renter-middle-name').text(renter.middleName);
    $('#view-add-renter-ext-name').text(renter.extension);
    $('#view-add-renter-contact-number').text(renter.contact);
    $('#view-add-renter-birthdate').text(renter.birthDate);

    $('#view-add-renter-valid-id-type').text(renter.validIdType);
    $('#view-add-renter-valid-id-number').text(renter.validIdNumber);

    $('#view-add-renter-room-number').text(roomNo); // ✅ This is now correct
    $('#view-add-renter-contract-term').text(renter.contractTermInMonths + " months");
    $('#view-add-renter-lease-start').text(renter.leaseStart);
    $('#view-add-renter-roomNo').text(roomNo); // header
    $('#view-add-renter-leaseStart').text(renter.leaseStart);
    $('#view-add-renter-email').text(email);
  } else {
    alert("Renter data not found.");
  }
});

$(document).on("click", ".button-table-view-archive-renter", function () {
  const renterId = $(this).data('renter-id');
  const renter = renterDataMap[renterId];

  if (renter) {
    const unitId = renter.unitId.trim();
    const room = roomsDataMap[unitId];
    const roomNo = room ? room.roomNo : "N/A";
    const userId = renter.userId.trim(); // ensure trimming
    const user = usersMap[userId];
    const email = user ? user.email : "N/A";

    // Populate modal fields
    $('#view-archive-renter-surname').text(renter.surname);
    $('#view-archive-renter-first-name').text(renter.firstName);
    $('#view-archive-renter-middle-name').text(renter.middleName);
    $('#view-archive-renter-ext-name').text(renter.extension);
    $('#view-archive-renter-contact-number').text(renter.contact);
    $('#view-archive-renter-birthdate').text(renter.birthDate);

    $('#view-archive-renter-valid-id-type').text(renter.validIdType);
    $('#view-archive-renter-valid-id-number').text(renter.validIdNumber);

    $('#view-archive-renter-room-number').text(roomNo);
    $('#view-archive-renter-roomNo').text(roomNo);
    $('#view-archive-renter-contract-term').text(renter.contractTermInMonths + " months");
    $('#view-archive-renter-lease-start').text(renter.leaseStart);
    $('#view-archive-renter-leaseStart').text(renter.leaseStart);
    $('#view-archive-renter-leaseEnd').text(renter.leaseEnd);
    $('#view-archive-renter-email').text(email);
    $('#view-archive-renter-leaving-reason').text(renter.deleteReason || "N/A");
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



function redirectToDashboard(role) {
  switch (role.toLowerCase()) {
    case "admin":
      window.location.href = "admin-dashboard.html";
      break;
    case "caretaker":
      window.location.href = "caretaker-dashboard.html";
      break;
    case "renter":
      window.location.href = "renter-dashboard.html";
      break;
    default:
      showError("User role is not recognized.", "#login-error-box", "#login-error-msg");
  }
}

function logout() {
  localStorage.removeItem("currentUser");
  window.location.href = "login.html";
}

function checkAccess(allowedRoles = []) {
  const currentUser = JSON.parse(localStorage.getItem("currentUser"));

  if (!currentUser || !currentUser.email || !currentUser.role) {
    window.location.href = "login.html";
    return;
  }

  if (!allowedRoles.includes(currentUser.role.toLowerCase())) {
    alert("Unauthorized access.");
    window.location.href = "login.html";
  }
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

function hasWhitespace(str) {
  return /\s/.test(str);
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

function calculateTotalCurrentBill() {
  let total = 0;
  // Get current year and month in 'YYYY-MM' format
  const now = new Date();
  const yearMonth = now.toISOString().slice(0, 7);

  // Sum rent bills for the current month
  for (const billId in rentBillsMap) {
    const bill = rentBillsMap[billId];
    if (bill.dueDate && bill.dueDate.startsWith(yearMonth)) {
      const amt = parseFloat(bill.amount);
      if (!isNaN(amt)) total += amt;
    }
  }

  // Sum utility bills for the current month
  for (const utilityType in utilityBillsMap) {
    const utility = utilityBillsMap[utilityType];
    utility.readings.forEach(reading => {
      if (reading.dueDate && reading.dueDate.startsWith(yearMonth)) {
        reading.bills.forEach(bill => {
          const amt = parseFloat(bill.amount);
          if (!isNaN(amt)) total += amt;
        });
      }
    });
  }

  return total;
}

function calculateTotalOverdueBills() {
  let total = 0;
  const today = new Date();

  // --- Rent Bills ---
  for (const billId in rentBillsMap) {
    const bill = rentBillsMap[billId];
    if (
      bill.status === "Unpaid" &&
      bill.dueDate &&
      new Date(bill.dueDate) < today
    ) {
      const amt = parseFloat(bill.amount);
      if (!isNaN(amt)) total += amt;
    }
  }

  // --- Utility Bills ---
  for (const utilityType in utilityBillsMap) {
    const utility = utilityBillsMap[utilityType];
    utility.readings.forEach(reading => {
      if (reading.dueDate && new Date(reading.dueDate) < today) {
        reading.bills.forEach(bill => {
          if (bill.status === "Unpaid") {
            const amt = parseFloat(bill.amount);
            if (!isNaN(amt)) total += amt;
          }
        });
      }
    });
  }

  return total;
}

function calculateTotalCurrentElectricBill() {
  let total = 0;
  const now = new Date();
  const yearMonth = now.toISOString().slice(0, 7); // e.g., "2025-05"

  // Check if Electricity bills exist
  const electricUtility = utilityBillsMap["Electricity"];
  if (electricUtility && Array.isArray(electricUtility.readings)) {
    electricUtility.readings.forEach(reading => {
      // Only consider readings for the current month
      if (reading.dueDate && reading.dueDate.startsWith(yearMonth)) {
        if (Array.isArray(reading.bills)) {
          reading.bills.forEach(bill => {
            const amt = parseFloat(bill.amount);
            if (!isNaN(amt)) total += amt;
          });
        }
      }
    });
  }
  return total;
}

function calculateTotalCurrentWaterBill() {
  let total = 0;
  const now = new Date();
  const yearMonth = now.toISOString().slice(0, 7); // "2025-05"
  const waterUtility = utilityBillsMap["Water"];
  if (waterUtility && Array.isArray(waterUtility.readings)) {
    waterUtility.readings.forEach(reading => {
      if (reading.dueDate && reading.dueDate.startsWith(yearMonth)) {
        if (Array.isArray(reading.bills)) {
          reading.bills.forEach(bill => {
            const amt = parseFloat(bill.amount);
            if (!isNaN(amt)) total += amt;
          });
        }
      }
    });
  }
  return total;
}

function calculateTotalCurrentRentBill() {
  let total = 0;
  const now = new Date();
  const yearMonth = now.toISOString().slice(0, 7); // "2025-05"
  for (const billId in rentBillsMap) {
    const bill = rentBillsMap[billId];
    if (bill.dueDate && bill.dueDate.startsWith(yearMonth)) {
      const amt = parseFloat(bill.amount);
      if (!isNaN(amt)) total += amt;
    }
  }
  return total;
}

