class PaymentContext {
  #selectedBillId = null;
  #selectedReadingId = null;
  #overdueBillIdsArray = [];
  #isOverduePayment = false;

  get selectedBillId() {
    return this.#selectedBillId;
  }
  set selectedBillId(value) {
    this.#selectedBillId = value;
  }

  get selectedReadingId() {
    return this.#selectedReadingId;
  }
  set selectedReadingId(value) {
    this.#selectedReadingId = value;
  }

  get overdueBillIdsArray() {
    return [...this.#overdueBillIdsArray];
  }
  set overdueBillIdsArray(value) {
    this.#overdueBillIdsArray = [...value];
  }

  get isOverduePayment() {
    return this.#isOverduePayment;
  }
  set isOverduePayment(value) {
    this.#isOverduePayment = value;
  }
}

const paymentContext = new PaymentContext();


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
        id: $(this).attr('id').trim(),
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
    updateTotalPayments(paymentsMap);
    updateCollectionRate(utilityBillsMap, rentBillsMap);
    updateOnTimePaymentRateByStatus(utilityBillsMap, rentBillsMap);
    // updateTotalCurrentBillsDueThisMonth(utilityBillsMap, rentBillsMap);

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
    updateTotalRenters(renterDataMap);
    updateOverdueRenters(renterDataMap);
    updateNumberOfRenterAccounts(usersMap);
    updateNumberOfCaretakerAccounts(usersMap);
    updateNumberOfInactiveAccounts(usersMap);
    updateNumberOfAccounts(usersMap);

    // --- Link renter's email ---
    Object.keys(renterDataMap).forEach(id => {
      const userId = renterDataMap[id].userId;
      if (usersMap[userId]) {
        renterDataMap[id].email = usersMap[userId].email;
      }
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


  // Usage example:
  const totalPendingTasks = calculateTotalPendingTasks();
  $('#total-pending-tasks').text(totalPendingTasks);

  
// Usage example:
const totalUrgentTasks = calculateTotalUrgentTasks();
$('#total-urgent-tasks').text(totalUrgentTasks);


function updateNumberOfAccounts(usersMap) {
  const totalUsers = Object.keys(usersMap).length;
  $('#total-accounts').text(totalUsers);
}

// Usage example:
const totalCompletedTasks = calculateTotalCompletedTasks();
$('#total-completed-tasks').text(totalCompletedTasks);


    const totalCurrentBill = calculateTotalCurrentBill();
    const formatted = totalCurrentBill.toLocaleString("en-PH", {minimumFractionDigits: 2, maximumFractionDigits: 2});
    $('#total-current-bill').text(formatted);
    $('#total-current-bills').text("PHP " + formatted);

    
// Usage example:
const totalOverdueTasks = calculateTotalOverdueTasks();
$('#total-overdue-tasks').text(totalOverdueTasks);


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

function formatPHP(amount) {
  return Number(amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// 1. Collect all due months from all readings and rent bills
let monthsSet = new Set();

Object.values(utilityBillsMap).forEach(utility => {
  utility.readings.forEach(reading => {
    if (reading.dueDate) monthsSet.add(reading.dueDate.slice(0, 7));
  });
});
Object.values(rentBillsMap).forEach(bill => {
  if (bill.dueDate) monthsSet.add(bill.dueDate.slice(0, 7));
});

let allMonths = Array.from(monthsSet).sort(); // Sort for display
let rowsHtml = '';

Object.keys(renterDataMap).forEach(renterId => {
  const renter = renterDataMap[renterId];
  if (!renter.unitId) return;

  const room = roomsDataMap[renter.unitId] || {};
  const roomNo = room.roomNo || '';
  const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

  allMonths.forEach(monthStr => {
    // --- Electric Bill ---
    let electricBill = 0, electricStatus = '';
    if (utilityBillsMap['Electricity']) {
      utilityBillsMap['Electricity'].readings.forEach(reading => {
        if (reading.dueDate && reading.dueDate.slice(0, 7) === monthStr) {
          reading.bills.forEach(bill => {
            if (String(bill.renterId) === String(renterId)) {
              electricBill += parseFloat(bill.amount) || 0;
              electricStatus = bill.status;
            }
          });
        }
      });
    }
    let electricInfo = getBadgeAndClass(electricStatus, electricBill);

    // --- Water Bill ---
    let waterBill = 0, waterStatus = '';
    if (utilityBillsMap['Water']) {
      utilityBillsMap['Water'].readings.forEach(reading => {
        if (reading.dueDate && reading.dueDate.slice(0, 7) === monthStr) {
          reading.bills.forEach(bill => {
            if (String(bill.renterId) === String(renterId)) {
              waterBill += parseFloat(bill.amount) || 0;
              waterStatus = bill.status;
            }
          });
        }
      });
    }
    let waterInfo = getBadgeAndClass(waterStatus, waterBill);

    // --- Rent Bill ---
    let rentBill = 0, rentStatus = '';
    Object.values(rentBillsMap).forEach(bill => {
      if (String(bill.renterId) === String(renterId) && bill.dueDate && bill.dueDate.slice(0, 7) === monthStr) {
        rentBill += parseFloat(bill.amount) || 0;
        rentStatus = bill.status;
      }
    });
    let rentInfo = getBadgeAndClass(rentStatus, rentBill);

    // --- Overdue: all unpaid bills with dueDate < today ---
    let today = new Date();
    let overdue = 0, overdueStatus = '';
    Object.values(rentBillsMap).forEach(bill => {
      if (String(bill.renterId) === String(renterId) && bill.status === 'Unpaid' && bill.dueDate && new Date(bill.dueDate) < today) {
        overdue += parseFloat(bill.amount) || 0;
        overdueStatus = bill.status;
      }
    });
    ['Electricity', 'Water'].forEach(type => {
      if (utilityBillsMap[type]) {
        utilityBillsMap[type].readings.forEach(reading => {
          if (reading.dueDate && new Date(reading.dueDate) < today) {
            reading.bills.forEach(bill => {
              if (String(bill.renterId) === String(renterId) && bill.status === 'Unpaid') {
                overdue += parseFloat(bill.amount) || 0;
                overdueStatus = bill.status;
              }
            });
          }
        });
      }
    });
    let overdueInfo = getBadgeAndClass(overdueStatus, overdue);

    // --- Total (for this month) ---
    let total = electricBill + waterBill + rentBill + overdue;
    let totalStatus = (electricStatus === 'Unpaid' || waterStatus === 'Unpaid' || rentStatus === 'Unpaid') ? 'Unpaid'
      : (electricStatus === 'Partial' || waterStatus === 'Partial' || rentStatus === 'Partial') ? 'Partial'
      : 'Paid';
    let totalInfo = getBadgeAndClass(totalStatus, total);

    // --- Total Unpaid: all unpaid bills for this renter ---
    let totalUnpaid = 0, unpaidStatus = '';
    // Rent Bills
    Object.values(rentBillsMap).forEach(bill => {
      if (String(bill.renterId) === String(renterId)) {
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
            if (String(bill.renterId) === String(renterId)) {
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

    // Only display row if there is any bill for this month
    if (electricBill || waterBill || rentBill) {
      let monthDueText = monthStr; // <-- formatted as YYYY-MM
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
    }
  });
});

$('#billings-summary tbody').html(rowsHtml);




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

    // Remove the notification button (if it exists)
    $('.electric-bill-card .btn-white[data-bs-target="#modalSendNotificationConfirmation"]').remove();
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

    // Remove the notification button (if it exists)
    $('.water-bill-card .btn-white[data-bs-target="#modalSendNotificationConfirmation"]').remove();
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

    // Remove the notification button (if it exists)
    $('.rent-bill-card .btn-white[data-bs-target="#modalSendNotificationConfirmation"]').remove();
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
  console.log("UPDATE OVERDUE BILL: ", overdueBills);
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

    // Remove the notification button (if it exists)
    $('.overdue-bill-card .btn-white[data-bs-target="#modalSendNotificationConfirmation"]').remove();
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
function getTrulyOverdueBillIds(renterId) {
  const today = new Date();
  const overdueBillIds = [];

  // Electricity
  if (utilityBillsMap['Electricity']) {
    utilityBillsMap['Electricity'].readings.forEach(reading => {
      if (
        reading.dueDate &&
        new Date(reading.dueDate) < today &&
        reading.bills.some(bill => bill.status === 'Unpaid' || bill.status === 'Partial')
      ) {
        reading.bills.forEach(bill => {
          if (
            bill.renterId === renterId &&
            (bill.status === 'Unpaid' || bill.status === 'Partial') &&
            (bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt)) > 0
          ) {
            overdueBillIds.push(bill.id);
          }
        });
      }
    });
  }

  // Water
  if (utilityBillsMap['Water']) {
    utilityBillsMap['Water'].readings.forEach(reading => {
      if (
        reading.dueDate &&
        new Date(reading.dueDate) < today &&
        reading.bills.some(bill => bill.status === 'Unpaid' || bill.status === 'Partial')
      ) {
        reading.bills.forEach(bill => {
          if (
            bill.renterId === renterId &&
            (bill.status === 'Unpaid' || bill.status === 'Partial') &&
            (bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt)) > 0
          ) {
            overdueBillIds.push(bill.id);
          }
        });
      }
    });
  }

  // Rent (use key as fallback if id is missing)
  Object.entries(rentBillsMap).forEach(([key, bill]) => {
    if (
      bill.renterId === renterId &&
      bill.dueDate &&
      new Date(bill.dueDate) < today &&
      (bill.status === 'Unpaid' || bill.status === 'Partial') &&
      (bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt)) > 0
    ) {
      overdueBillIds.push(key);
      console.log("ADDED KEY: " + key);
    }
  });

  return overdueBillIds;
}


function populateOverdueBillsCard(renterId) {
  console.log("--- populateOverdueBillsCard ---");
  console.log("renterId:", renterId);

  let today = new Date();
  console.log("Today:", today.toISOString().split('T')[0]);

  let electricOverdue = 0, waterOverdue = 0, rentOverdue = 0;
  let electricDueDate = '', waterDueDate = '', rentDueDate = '';

  // --- Electric Overdue ---
  if (utilityBillsMap['Electricity']) {
    console.log("Checking overdue Electricity bills...");
    utilityBillsMap['Electricity'].readings.forEach(reading => {
      if (
        reading.dueDate &&
        new Date(reading.dueDate) < today &&
        // Skip if all bills are paid (for any renter)
        reading.bills.some(bill => bill.status === 'Unpaid' || bill.status === 'Partial')
      ) {
        console.log("Found overdue reading with unpaid bills (Electricity):", reading);
        reading.bills.forEach(bill => {
          if (bill.renterId === renterId && (bill.status === 'Unpaid' || bill.status === 'Partial')) {
            // For 'Unpaid', use bill.amount; for 'Partial', use bill.debt
            const amount = bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt);
            console.log("Found overdue bill (Electricity):", bill, "Amount:", amount);
            electricOverdue += amount;
            electricDueDate = reading.dueDate; // Use the latest found
          }
        });
      }
    });
    console.log("Total Electric overdue:", electricOverdue, "Due date:", electricDueDate);
  } else {
    console.log("No Electricity bills map found");
  }

  // --- Water Overdue ---
  if (utilityBillsMap['Water']) {
    console.log("Checking overdue Water bills...");
    utilityBillsMap['Water'].readings.forEach(reading => {
      if (
        reading.dueDate &&
        new Date(reading.dueDate) < today &&
        // Skip if all bills are paid (for any renter)
        reading.bills.some(bill => bill.status === 'Unpaid' || bill.status === 'Partial')
      ) {
        console.log("Found overdue reading with unpaid bills (Water):", reading);
        reading.bills.forEach(bill => {
          if (bill.renterId === renterId && (bill.status === 'Unpaid' || bill.status === 'Partial')) {
            // For 'Unpaid', use bill.amount; for 'Partial', use bill.debt
            const amount = bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt);
            console.log("Found overdue bill (Water):", bill, "Amount:", amount);
            waterOverdue += amount;
            waterDueDate = reading.dueDate;
          }
        });
      }
    });
    console.log("Total Water overdue:", waterOverdue, "Due date:", waterDueDate);
  } else {
    console.log("No Water bills map found");
  }

  // --- Rent Overdue ---
  console.log("Checking overdue Rent bills...");
  Object.values(rentBillsMap).forEach(bill => {
    if (
      bill.renterId === renterId &&
      bill.dueDate &&
      new Date(bill.dueDate) < today &&
      (bill.status === 'Unpaid' || bill.status === 'Partial')
    ) {
      // For 'Unpaid', use bill.amount; for 'Partial', use bill.debt
      const amount = bill.status === 'Unpaid' ? parseFloat(bill.amount) : parseFloat(bill.debt);
      console.log("Found overdue bill (Rent):", bill, "Amount:", amount);
      rentOverdue += amount;
      rentDueDate = bill.dueDate;
    }
  });
  console.log("Total Rent overdue:", rentOverdue, "Due date:", rentDueDate);

  const overdueBills = getOverdueBillsForRenter(renterId);
  console.log("getOverdueBillsForRenter result:", overdueBills);
  updateOverdueBillCard(overdueBills, renterId);
  console.log("updateOverdueBillCard called");

  // --- Update the UI ---
  $('#overdue-electric').text('PHP ' + Number(electricOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));
  $('#overdue-water').text('PHP ' + Number(waterOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));
  $('#overdue-rent').text('PHP ' + Number(rentOverdue).toLocaleString('en-PH', {minimumFractionDigits:2}));
  console.log("Updated overdue amounts in UI");

  // Electric Due Date
  if (electricOverdue > 0 && electricDueDate) {
    $('#overdue-electric-due-date').text(electricDueDate);
    $('#overdue-electric-due-date-container').show();
    console.log("Set Electric due date:", electricDueDate);
  } else {
    $('#overdue-electric-due-date').text('');
    $('#overdue-electric-due-date-container').hide();
    console.log("No Electric due date to display");
  }

  // Water Due Date
  if (waterOverdue > 0 && waterDueDate) {
    $('#overdue-water-due-date').text(waterDueDate);
    $('#overdue-water-due-date-container').show();
    console.log("Set Water due date:", waterDueDate);
  } else {
    $('#overdue-water-due-date').text('');
    $('#overdue-water-due-date-container').hide();
    console.log("No Water due date to display");
  }

  // Rent Due Date
  if (rentOverdue > 0 && rentDueDate) {
    $('#overdue-rent-due-date').text(rentDueDate);
    $('#overdue-rent-due-date-container').show();
    console.log("Set Rent due date:", rentDueDate);
  } else {
    $('#overdue-rent-due-date').text('');
    $('#overdue-rent-due-date-container').hide();
    console.log("No Rent due date to display");
  }

  // --- Set Overdue Bill IDs on the Overdue Payment Button ---
  const overdueBillIds = getTrulyOverdueBillIds(renterId);
  console.log("Set overdue bill IDs for pay-btn.overdue:", overdueBillIds);
  $('.pay-btn.overdue[data-renter-id="' + renterId + '"]').attr('data-bill-ids', overdueBillIds.join(','));
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

// let selectedBillId = null;          // e.g., "E1" or "W3" or "101"
// let selectedReadingId = null;       // e.g., "1" (reading id for utilities)
// let overdueBillIdsArray = [];       // e.g., ["E1", "W1", "101"]
// let isOverduePayment = false;       // true if paying multiple bills (overdue)

$(document).on('click', '.pay-btn', function() {
  console.log("--- .pay-btn clicked ---");
  const type = $(this).attr('data-type');
  // If your HTML uses 'Electric', consider mapping it here:
  // const mappedType = type === 'Electric' ? 'Electricity' : type;
  // For now, we use type as-is, but in logic, we use 'Electricity'
  const billId = $(this).attr('data-bill-id');
  const readingId = $(this).attr('data-reading-id');
  const renterId = $(this).attr('data-renter-id');
  console.log("type:", type, "billId:", billId, "readingId:", readingId, "renterId:", renterId);

  let bill = null;
  let reading = null;
  let billsToPay = [];

  if (type === 'Electricity' && utilityBillsMap['Electricity']) {
    console.log("Looking for Electricity bill...");
    reading = utilityBillsMap['Electricity'].readings.find(r => r.id == readingId);
    if (reading) {
      console.log("Found reading:", reading);
      bill = reading.bills.find(b => b.id == billId);
      if (bill) console.log("Found bill:", bill);
      else console.log("Bill not found in reading");
    } else {
      console.log("Reading not found");
    }
  } else if (type === 'Water' && utilityBillsMap['Water']) {
    console.log("Looking for Water bill...");
    reading = utilityBillsMap['Water'].readings.find(r => r.id == readingId);
    if (reading) {
      console.log("Found reading:", reading);
      bill = reading.bills.find(b => b.id == billId);
      if (bill) console.log("Found bill:", bill);
      else console.log("Bill not found in reading");
    } else {
      console.log("Reading not found");
    }
  } else if (type === 'Rent') {
    console.log("Looking for Rent bill...");
    bill = rentBillsMap[billId];
    if (bill) console.log("Found bill:", bill);
    else console.log("Rent bill not found");
  } else if (type === 'Overdue') {
    console.log("Looking for Overdue bills...");
    const billIdsStr = $(this).attr('data-bill-ids') || '';
    console.log("BillIdsStr", billIdsStr);
    const billIds = billIdsStr.split(',').map(id => id.trim()).filter(id => id);
    console.log("Overdue bill IDs:", billIds);

    billIds.forEach(id => {
      let foundBill = null;
      // Electricity
      if (!foundBill && utilityBillsMap['Electricity']) {
        console.log("Checking Electricity for bill ID:", id);
        for (const reading of utilityBillsMap['Electricity'].readings) {
          if (Array.isArray(reading.bills)) {
            foundBill = reading.bills.find(b => b.id === id);
          } else if (reading.bill) {
            const billsArr = Array.isArray(reading.bill) ? reading.bill : [reading.bill];
            foundBill = billsArr.find(b => b.id === id);
          }
          if (foundBill) {
            console.log("Found bill in Electricity:", foundBill);
            break;
          }
        }
      }
      // Water
      if (!foundBill && utilityBillsMap['Water']) {
        console.log("Checking Water for bill ID:", id);
        for (const reading of utilityBillsMap['Water'].readings) {
          if (Array.isArray(reading.bills)) {
            foundBill = reading.bills.find(b => b.id === id);
          } else if (reading.bill) {
            const billsArr = Array.isArray(reading.bill) ? reading.bill : [reading.bill];
            foundBill = billsArr.find(b => b.id === id);
          }
          if (foundBill) {
            console.log("Found bill in Water:", foundBill);
            break;
          }
        }
      }
      // Rent
      if (!foundBill && rentBillsMap[id]) {
        console.log("Checking Rent for bill ID:", id);
        foundBill = rentBillsMap[id];
        if (foundBill) console.log("Found bill in Rent:", foundBill);
      }
      if (foundBill) {
        billsToPay.push(foundBill);
        console.log("Added bill to billsToPay:", foundBill);
      } else {
        console.log("Bill ID not found:", id);
      }
    });

    if (billsToPay.length === 0) {
      console.log("No overdue bills found");
      alert("No overdue bills found. Please check the data attributes.");
      return;
    }
    console.log("billsToPay:", billsToPay);
  }

  // If not overdue type, check if bill found
  if (type !== 'Overdue' && !bill) {
    console.log("Bill not found");
    alert("Bill not found. Please check the data attributes.");
    return;
  }

  // === SET PAYMENT CONTEXT ===
  if (type === 'Overdue') {
    console.log("Setting context for overdue payment");
    paymentContext.isOverduePayment = true;
    paymentContext.overdueBillIdsArray = billsToPay.map(b => b.id);
    paymentContext.selectedBillId = null;
    paymentContext.selectedReadingId = null;
  } else {
    console.log("Setting context for single bill payment");
    paymentContext.isOverduePayment = false;
    paymentContext.selectedBillId = billId || null;
    paymentContext.selectedReadingId = readingId || null;
    paymentContext.overdueBillIdsArray = [];
  }
  console.log("paymentContext:", {
    isOverduePayment: paymentContext.isOverduePayment,
    overdueBillIdsArray: paymentContext.overdueBillIdsArray,
    selectedBillId: paymentContext.selectedBillId,
    selectedReadingId: paymentContext.selectedReadingId
  });

  // Set modal fields
  $('#record-payment-renter').val(renterId);
  console.log("Set renter ID:", renterId);

  // --- CHECKBOX LOGIC ---
  if (type === 'Overdue') {
    console.log("Setting checkboxes for overdue payment");
    $('#record-payment-electric-checkbox').prop('checked', false);
    $('#record-payment-water-checkbox').prop('checked', false);
    $('#record-payment-rent-checkbox').prop('checked', false);

    const typesPresent = new Set(billsToPay.map(b => b.type || 
      (b.id && b.id.startsWith('E') ? 'Electricity' : 
       b.id && b.id.startsWith('W') ? 'Water' : 
       b.id && b.id.startsWith('R') ? 'Rent' : null)
    ));
    if (typesPresent.has('Electricity')) {
      $('#record-payment-electric-checkbox').prop('checked', true);
      console.log("Checked Electricity");
    }
    if (typesPresent.has('Water')) {
      $('#record-payment-water-checkbox').prop('checked', true);
      console.log("Checked Water");
    }
    if (typesPresent.has('Rent')) {
      $('#record-payment-rent-checkbox').prop('checked', true);
      console.log("Checked Rent");
    }
  } else {
    console.log("Setting checkboxes for single bill payment");
    $('#record-payment-electric-checkbox').prop('checked', type === 'Electricity');
    $('#record-payment-water-checkbox').prop('checked', type === 'Water');
    $('#record-payment-rent-checkbox').prop('checked', type === 'Rent');
    console.log("Electricity:", type === 'Electricity', "Water:", type === 'Water', "Rent:", type === 'Rent');
  }

  // --- AMOUNT LOGIC ---
let amount = 0;
if (type === 'Overdue') {
  console.log("Calculating amount for overdue bills");
  amount = billsToPay.reduce((sum, b) => {
    return sum + (b.status === 'Unpaid' ? Number(b.amount) : Number(b.debt));
  }, 0);
  console.log("Total amount for overdue bills:", amount);
} else {
  console.log("Calculating amount for single bill");
  if (bill.status === 'Partial') {
    amount = Number(bill.debt);
    console.log("Partial bill, amount:", amount);
  } else {
    amount = Number(bill.amount);
    console.log("Full bill, amount:", amount);
  }
}


  $('#record-payment-payment-amount').val(amount);
  console.log("Set payment amount:", amount);

  $('#record-payment-payment-date').val(formatDateToYYYYMMDD(new Date()));
  console.log("Set payment date");

  $('#record-payment-receipt-number').text(getNextReceiptNumber());
  console.log("Set receipt number");

  $('#modalRecordPayment').modal('show');
  console.log("Showed modal");
});
























  }
});



   


function displaySuccessModal() {
  const url = new URL(window.location.href);
  const urlParams = url.searchParams;

  // Handle renter actions
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

  // Handle login actions
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

  // Handle payment success
  const payStatus = urlParams.get('pay');
  if (payStatus === 'recorded') {
    $('#modalRecordPaymentSuccess').modal('show');
  }

  // Handle electric bill added success
  const electricBillStatus = urlParams.get('electricbill');
  if (electricBillStatus === 'added') {
    $('#modalGenerateElectricBillSuccess').modal('show');
  }

  // NEW: Handle electric bill modified success
  if (electricBillStatus === 'modified') {
    $('#modalModifyElectricBillSuccess').modal('show');
  }

  // Handle water bill added success
  const waterBillStatus = urlParams.get('waterbill');
  if (waterBillStatus === 'added') {
    $('#modalGenerateWaterBillSuccess').modal('show');
  }

  // Handle electric metadata modified success
  const electricMetadataStatus = urlParams.get('electricmetadata');
  if (electricMetadataStatus === 'modified') {
    $('#modalModifyElectricMetadataSuccess').modal('show');
  }

  // Handle water metadata modified success
  const waterMetadataStatus = urlParams.get('watermetadata');
  if (waterMetadataStatus === 'modified') {
    $('#modalModifyWaterMetadataSuccess').modal('show');
  }

  // Handle task completion success
  const completeStatus = urlParams.get('complete');
  if (completeStatus === 'success') {
    $('#modalCompleteTaskSuccess').modal('show');
  }

  // Handle task actions
  const taskAction = urlParams.get('task');
  if (taskAction === 'added') {
    $('#modalAddTaskSuccess').modal('show');
  } else if (taskAction === 'modified') {
    $('#modalModifyTaskSuccess').modal('show');
  } else if (taskAction === 'deleted') {
    $('#modalDeleteTaskSuccess').modal('show');  // <-- New block for deleted task
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

  const userData = JSON.parse(localStorage.getItem('currentUser'));
  if (userData && userData.email) {
    $('#usernameOnRenterDashboard').text(userData.email);
  }

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



  
$('#button-add-task').on("click", function () {
  
    // Collect input values
    const template = $("#add-task-common-tasks-templates").val();
    const title = $("#add-task-title").val().trim();
    const type = $("#add-task-type").val();
    // Note: The due date input in your HTML has id="add-renter-lease-start" (likely a copy-paste error)
    // For tasks, it should be: id="add-task-due-date"
    const dueDate = $("#add-task-due-date").val();
    const concernedWith = $("#add-task-concerned-with").val();

    // Generate a Task ID (you can use a better method as needed)
    // const taskId = 'TASK-' + Date.now();

    // Validation
    if (!title || !type || !dueDate || !concernedWith) {
        return showError("All required fields must be filled.", "#error-box-add-task", "#error-text-add-task");
    }

    if (title.length > 100) {
        return showError("Title exceeds length limit.", "#error-box-add-task", "#error-text-add-task");
    }

    // Add more validation as needed (e.g., date in the future, valid type, etc.)

    // Fill confirmation modal
    // $("#confirm-add-task-task-id").text(taskId);
    $("#confirm-add-task-title").text(title);
    $("#confirm-add-task-type").text(type);
    $("#confirm-add-task-due-date").text(dueDate);
    $("#confirm-add-task-concerned-with").text(concernedWith);

    // Optionally, store hidden fields for submission
    // $("#hidden-add-task-task-id").val(taskId);
    $("#hidden-add-task-title").val(title);
    $("#hidden-add-task-type").val(type);
    $("#hidden-add-task-due-date").val(dueDate);
    $("#hidden-add-task-concerned-with").val(concernedWith);

    // Hide error, close input modal, show confirmation modal
    hideError("#error-box-add-task", "#error-text-add-task");
    $('#modalAddTask').modal('hide');
    $('#modalAddTaskConfirmation').modal('show');
});

// When the edit button is clicked, retrieve the task ID from data attribute
$('.button-task-edit').on('click', function() {
  const taskId = $(this).data('task-id'); // jQuery automatically reads data-task-id
  // Now you can use taskId, for example, set it into your modal input
  $('#hidden-modify-task-task-id').val(taskId);

  // Optionally, load other task data into the modal here...

  // console.log('Editing task with ID:', taskId);
});


$('#button-modify-task').on("click", function () {
    // console.log(this);
    // Collect input values
    const taskId = $("#modify-task-task-id").val(); // Get from input or confirmation
    const title = $("#modify-task-title").val().trim();
    const type = $("#modify-task-type").val();
    const dueDate = $("#modify-task-due-date").val();
    const concernedWith = $("#modify-task-concerned-with").val();

    // Validation
    if (!title || !type || !dueDate || !concernedWith) {
        return showError("All required fields must be filled.", "#error-box-modify-task", "#error-text-modify-task");
    }
    if (title.length > 100) {
        return showError("Title exceeds length limit.", "#error-box-modify-task", "#error-text-modify-task");
    }
    // Add more validation as needed

    // Fill confirmation modal
    $("#confirm-modify-task-task-id").text(taskId);
    $("#confirm-modify-task-title").text(title);
    $("#confirm-modify-task-type").text(type);
    $("#confirm-modify-task-due-date").text(dueDate);
    $("#confirm-modify-task-concerned-with").text(concernedWith);

    // Fill hidden fields for PHP
    // $("#hidden-modify-task-task-id").val(taskId);
    $("#hidden-modify-task-title").val(title);
    $("#hidden-modify-task-type").val(type);
    $("#hidden-modify-task-due-date").val(dueDate);
    $("#hidden-modify-task-concerned-with").val(concernedWith);

    // Hide error, close input modal, show confirmation modal
    hideError("#error-box-modify-task", "#error-text-modify-task");
    $('#modalModifyTask').modal('hide');
    $('#modalModifyTaskConfirmation').modal('show');
});

// When the edit button is clicked, retrieve the task ID from data attribute
$('.button-task-delete').on('click', function() {
  const taskId = $(this).data('task-id'); // jQuery automatically reads data-task-id
  // Now you can use taskId, for example, set it into your modal input
  $('#hidden-delete-task-task-id').val(taskId);
  $("#confirm-delete-task-task-id").text(taskId);


  // Optionally, load other task data into the modal here...

  // console.log('Editing task with ID:', taskId);
});

$('#button-delete-task').on("click", function () {
    // Collect input values from modal inputs or confirmation text
    // const taskId = $("#delete-task-task-id").val();
    const title = $("#delete-task-title").val().trim();
    const type = $("#delete-task-type").val();
    const dueDate = $("#delete-task-due-date").val();
    const concernedWith = $("#delete-task-concerned-with").val();
    const reason = $("#remove-task-reason").val();

    // Validation
    if (!taskId || !title || !type || !dueDate || !concernedWith) {
        return showError("All task details must be present.", "#error-box-delete-task", "#error-text-delete-task");
    }
    if (!reason) {
        return showError("Please select a reason for deleting the task.", "#error-box-delete-task", "#error-text-delete-task");
    }

    // Fill confirmation modal text (if needed)
    $("#confirm-delete-task-title").text(title);
    $("#confirm-delete-task-type").text(type);
    $("#confirm-delete-task-due-date").text(dueDate);
    $("#confirm-delete-task-concerned-with").text(concernedWith);

    // Fill hidden fields for PHP submission
    // $("#hidden-delete-task-task-id").val(taskId);
    $("#hidden-delete-task-title").val(title);
    $("#hidden-delete-task-type").val(type);
    $("#hidden-delete-task-due-date").val(dueDate);
    $("#hidden-delete-task-concerned-with").val(concernedWith);
    $("#hidden-delete-task-reason").val(reason);

    // Hide error, close input modal, show confirmation modal
    hideError("#error-box-delete-task", "#error-text-delete-task");
    $('#modalDeleteTask').modal('hide');
    $('#modalDeleteTaskConfirmation').modal('show');
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
   $(document).ready(function () {
    const templateData = {
      'pay-water-bill': {
        title: 'Pay Water Bill',
        type: 'Utility' // must match option value in #add-task-type
      },
      'pay-electricity-bill': {
        title: 'Pay Electricity Bill',
        type: 'Utility'
      },
      'send-rent-reminder': {
        title: 'Send Rent Reminder',
        type: 'Maintenance'
      },
      'collect-rent-payment': {
        title: 'Collect Rent Payment',
        type: 'Collection' // adjust if needed
      }
    };

    $('#add-task-common-tasks-templates').on('change', function () {
      const selectedValue = $(this).val();
      if (templateData[selectedValue]) {
        $('#add-task-title').val(templateData[selectedValue].title || '');

        const typeValue = templateData[selectedValue].type || '';
        const $typeSelect = $('#add-task-type');
        const $matchingOption = $typeSelect.find('option[value="' + typeValue + '"]');
        if ($matchingOption.length) {
          $typeSelect.val(typeValue);
        } else {
          $typeSelect.prop('selectedIndex', 0);
        }
      } else {
        $('#add-task-title').val('');
        $('#add-task-type').prop('selectedIndex', 0);
      }
    });
  });
  

// Start
// Listen for clicks on complete buttons
$(document).on('click', '.button-view-room', function() {
  const roomId = $(this).data('room-id'); // Make sure your buttons have data-room-id attribute

  if (!roomId || !roomsDataMap[roomId]) {
    console.error('Room ID not found or room data missing for ID:', roomId);
    return;
  }

  const room = roomsDataMap[roomId];

  // Populate modal fields
  $('#view-room-room-number').text(room.roomNo);
  $('#view-room-floor-number').text(room.floorNo);
  $('#view-room-room-type').text(room.roomType);
  $('#view-room-size').text(room.sizeSQM);
  $('#view-room-rent-price').text(room.rentPrice);
  $('#view-room-status').text(room.status);

  // The modal will show automatically if your button has data-bs-toggle="modal" and data-bs-target="#modalViewRoomDetails"
  // Otherwise, you can manually show modal:
  // $('#modalViewRoomDetails').modal('show');
});

// Populate View Room modal
$(document).on('click', '.button-view-room', function() {
  const roomId = $(this).data('room-id');

  if (!roomId || !roomsDataMap[roomId]) {
    console.error('Room ID not found or room data missing for ID:', roomId);
    return;
  }

  const room = roomsDataMap[roomId];

  $('#view-room-room-number').text(room.roomNo);
  $('#view-room-floor-number').text(room.floorNo);
  $('#view-room-room-type').text(room.roomType);
  $('#view-room-size').text(room.sizeSQM);
  $('#view-room-rent-price').text(room.rentPrice);
  $('#view-room-status').text(room.status);
});

// Populate Modify Room modal
$(document).on('click', '.button-edit-room', function() {
  const roomId = $(this).data('room-id');

  if (!roomId || !roomsDataMap[roomId]) {
    console.error('Room ID not found or room data missing for ID:', roomId);
    return;
  }

  const room = roomsDataMap[roomId];

  // Populate inputs and selects
  $('#modify-room-room-number').val(room.roomNo);

  // Set floor select by matching option value
  $('#modify-room-floor-number option').each(function() {
    if ($(this).val() === room.floorNo) {
      $(this).prop('selected', true);
      return false; // break loop
    }
  });

  // Set room type select by matching option value
  $('#modify-room-room-type option').each(function() {
    if ($(this).val() === room.roomType) {
      $(this).prop('selected', true);
      return false;
    }
  });

  $('#modify-room-size').val(room.sizeSQM);
  $('#modify-room-rent-price').val(room.rentPrice);
});

// Populate Delete Room Confirmation modal
$(document).on('click', '.button-delete-room', function() {
  const roomId = $(this).data('room-id');

  if (!roomId || !roomsDataMap[roomId]) {
    console.error('Room ID not found or room data missing for ID:', roomId);
    return;
  }

  const room = roomsDataMap[roomId];

  // Populate modal fields with updated IDs
  $('#confirm-remove-room-room-number').text(room.roomNo);
  $('#confirm-remove-room-floor-number').text(room.floorNo);
  $('#confirm-remove-room-room-type').text(room.roomType);
  $('#confirm-remove-room-size').text(room.sizeSQM);
  $('#confirm-remove-room-rent-price').text(room.rentPrice);

  // Reset the delete reason select to default
  $('#remove-room-reason').val('');
});


  $(document).on('click', '.button-task-complete', function() {
    const taskId = $(this).data('task-id'); // Assuming your buttons have data-task-id attribute

    if (!taskId || !tasksMap[taskId]) {
      console.error('Task ID not found or task data missing for ID:', taskId);
      return;
    }

    const task = tasksMap[taskId];

    // Populate modal fields
    $('#confirm-complete-task-task-id').text(taskId);
    $('#confirm-complete-task-title').text(task.title);
    $('#confirm-complete-task-type').text(task.type);
    $('#confirm-complete-task-due-date').text(task.dueDate);
    $('#confirm-complete-task-concerned-with').text(task.concernedWith);

    // The modal will show automatically if your button has data-bs-toggle="modal" and data-bs-target="#modalCompleteTaskConfirmation"
    // Otherwise, you can manually show modal:
    // $('#modalCompleteTaskConfirmation').modal('show');
  });


  $(document).on('click', '.button-task-edit', function() {
    const taskId = $(this).data('task-id');

    if (!taskId || !tasksMap[taskId]) {
      console.error('Task ID not found or task data missing for ID:', taskId);
      return;
    }

    const task = tasksMap[taskId];

    // Populate the Title input
    $('#modify-task-title').val(task.title);

    // Populate the Type select (match option value)
    const $typeSelect = $('#modify-task-type');
    if (task.type) {
      const $option = $typeSelect.find(`option[value="${task.type}"]`);
      if ($option.length) {
        $typeSelect.val(task.type);
      } else {
        $typeSelect.prop('selectedIndex', 0);
      }
    } else {
      $typeSelect.prop('selectedIndex', 0);
    }

    // Populate the Due Date input (assumes input type="date" accepts yyyy-mm-dd)
    if (task.dueDate) {
      // Convert to yyyy-mm-dd if needed, assuming task.dueDate is ISO or similar
      $('#modify-task-due-date').val(task.dueDate);
    } else {
      $('#modify-task-due-date').val('');
    }

    // Populate Concerned With select
    const $concernedSelect = $('#modify-task-concerned-with');
    if (task.concernedWith) {
      const $concernedOption = $concernedSelect.find(`option[value="${task.concernedWith}"]`);
      if ($concernedOption.length) {
        $concernedSelect.val(task.concernedWith);
      } else {
        $concernedSelect.prop('selectedIndex', 0);
      }
    } else {
      $concernedSelect.prop('selectedIndex', 0);
    }

    // Populate the Common Tasks Template select based on title or type if you want
    const $templateSelect = $('#modify-task-common-tasks-templates');
    // Example mapping title to template value (adjust as needed)
    const titleToTemplateMap = {
      'Pay Water Bill': 'pay-water-bill',
      'Pay Electricity Bill': 'pay-electricity-bill',
      'Send Rent Reminder': 'send-rent-reminder',
      'Collect Rent Payment': 'collect-rent-payment'
    };
    const templateValue = titleToTemplateMap[task.title] || '';
    if (templateValue) {
      $templateSelect.val(templateValue);
    } else {
      $templateSelect.prop('selectedIndex', 0);
    }
  });

  $(document).on('click', '.button-task-delete', function() {
    const taskId = $(this).data('task-id');

    if (!taskId || !tasksMap[taskId]) {
      console.error('Task ID not found or task data missing for ID:', taskId);
      return;
    }

    const task = tasksMap[taskId];

    // Populate modal fields
    $('#confirm-delete-task-task-id').text(taskId);
    $('#confirm-delete-task-title').text(task.title);
    $('#confirm-delete-task-type').text(task.type);
    $('#confirm-delete-task-due-date').text(task.dueDate);
    $('#confirm-delete-task-concerned-with').text(task.concernedWith);

    // Reset the delete reason select to default (hidden placeholder)
    $('#remove-task-reason').val('');
  });

  $('.button-task-complete').on('click', function() {
    var taskId = $(this).data('task-id');
    $('#completeTaskId').val(taskId);
  });



$(document).ready(function () {
  $('#button-check').on("click", function () {
    $('#modalCompleteTaskConfirmation').modal('show');
  });
});

$(document).ready(function () {
  $('#button-delete').on("click", function () {
    $('#modalDeleteTaskConfirmation').modal('show');
  });
});

$('#button-add-room').on("click", function () {
    $('#modalAddRoom').modal('hide');
    $('#modalAddRoomConfirmation').modal('show');
  });

$(document).ready(function () {
  $('#button-view').on("click", function () {
    $('#modalViewRoom').modal('show');
  });
});

$('#button-modify-room').on("click", function () {
    $('#modalModifyRoom').modal('hide');
    $('#modalModifyRoomConfirmation').modal('show');
  });

  $(document).ready(function () {
  $('#button-delete').on("click", function () {
    $('#modalDeleteRoomConfirmation').modal('show');
  });
});

$('#button-add-account').on("click", function () {
  $('#modalAddAccount').modal('hide'); 
  $('#modalAddAccountConfirmation').modal('show');
});

  $('#button-modify-account').on("click", function () {
    $('#modalModifyAccount').modal('hide');
    $('#modalModifyAccountConfirmation').modal('show');
  });

$(document).ready(function () {
  $('#button-delete').on("click", function () {
    $('#modalDeleteAccountConfirmation').modal('show');
  });
});
// End

  $('#button-confirm-send-notif').on("click", function () {
    const renterID = $('#select-billings-renter').val();
    $('#modalSendNotificationConfirmation').modal('hide');
    $('#modalSendNotificationSuccess').modal('show');
    // TODO: Set renter name for modal
    // TODO: Renter ID
    sendNotification(renterID);
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
  
function populateElectricBillTable() {
  const $tbody = $('#modalGenerateElectricBill table.custom-table tbody');
  $tbody.empty();

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return; // Skip if no unit assigned

    // Skip archived renters
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    const today = new Date();
    const currentMonth = today.toISOString().slice(0, 7); // e.g., '2025-05'

    let previousReading = getPreviousWaterReading(renterId, currentMonth);

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>
          <div class="form-floating me-2 col-12 mt-3">
            <input type="hidden" class="renter-id" value="${renterId}" />
            <input type="text" class="form-control current-reading" data-renter-id="${renterId}" placeholder="" required="required"/>
            <label>Current Reading *</label>
          </div>
        </td>
        <td>${previousReading}</td>
        <td class="consumed-kwh">0</td>
        <td class="amount-per-kwh">0</td>
        <td class="total">0</td>
      </tr>
    `);
  });

  // Add a summary row
  $tbody.append(`
    <tr class="fw-bolder">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td class="total-consumed-kwh">0</td>
      <td></td>
      <td class="grand-total">0</td>
    </tr>
  `);
}

$('#modalGenerateElectricBill').on('shown.bs.modal', function() {
  populateElectricBillTable();
});
$(document).on('input', '.current-reading', function() {
  const $row = $(this).closest('tr');
  const currentReading = parseFloat($(this).val()) || 0;
  const previousReading = parseFloat($row.find('td:eq(3)').text()) || 0;
  const consumedKwh = currentReading - previousReading;
  $row.find('.consumed-kwh').text(consumedKwh);

  // Get amount per kwh (from total bill / total consumed kwh)
  const totalBill = parseFloat($('#add-billings-electric-total-bill').val()) || 0;
  let totalConsumedKwh = 0;
  $('.consumed-kwh').each(function() {
    totalConsumedKwh += parseFloat($(this).text()) || 0;
  });
  $('.total-consumed-kwh').text(totalConsumedKwh);

  const amountPerKwh = totalConsumedKwh > 0 ? (totalBill / totalConsumedKwh) : 0;
  $('.amount-per-kwh').text('PHP ' + formatPHP(amountPerKwh));

  // Compute total for each renter
  $('.consumed-kwh').each(function() {
    const consumed = parseFloat($(this).text()) || 0;
    const total = consumed * amountPerKwh;
    $(this).closest('tr').find('.total').text('PHP ' + formatPHP(total));
  });

  // Update grand total
  let grandTotal = 0;
  $('.total').each(function() {
    grandTotal += parseFloat($(this).text().replace('PHP ', '').replace(/,/g, '')) || 0;
  });
  $('.grand-total').text('PHP ' + formatPHP(grandTotal));
});

// Also trigger computation when total bill changes
$('#add-billings-electric-total-bill').on('input', function() {
  $('.current-reading').trigger('input');
});

function formatPHP(amount) {
  return Number(amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function formatPHP(amount) {
  return Number(amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function isNumber(val) {
  return !isNaN(parseFloat(val)) && isFinite(val);
}

function isDecimal(val) {
  return /^(\d+(\.\d{1,2})?)$/.test(val.replace(/,/g, ''));
}

// When the modal opens, set due date and populate table and total bill
$('#modalModifyElectricBill').on('shown.bs.modal', function() {
  const monthStr = $('#electric-bill-month-due').val();
  if (!monthStr) return;

  let dueDate = '';
  if (utilityBillsMap['Electricity']) {
    const reading = utilityBillsMap['Electricity'].readings.find(r => 
      r.dueDate && r.dueDate.startsWith(monthStr));
    if (reading) {
      dueDate = reading.dueDate;
    }
  }

  $('#modify-electric-bill-month-due').val(dueDate);
  populateModifyElectricBillTable(dueDate);
});

// Populates the Modify Electric Bill table
function populateModifyElectricBillTable(dueDate) {
  const $tbody = $('#modalModifyElectricBill table.custom-table tbody');
  $tbody.empty();

  let totalConsumedKwh = 0;
  let grandTotal = 0;
  let totalBillFromXML = 0;
  let readingId = '';

  let reading = null;
  if (utilityBillsMap['Electricity']) {
    reading = utilityBillsMap['Electricity'].readings.find(r => r.dueDate && r.dueDate === dueDate);
    if (reading) {
      readingId = reading.id || '';
      totalBillFromXML = parseFloat(reading.totalBill) || 0;
    }
  }

  // Store reading ID for form submission
  $('#form-modify-electric').data('readingId', readingId);

  $('#modify-billings-electric-total-bill').val(totalBillFromXML ? formatPHP(totalBillFromXML) : '');

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return;
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    let bill = null, previousReading = 0, currentReading = '', consumedKwh = 0, amountPerKwh = 0, total = 0, billId = '';
    if (reading && reading.bills) {
      bill = reading.bills.find(b => String(b.renterId) === String(renterId));
      if (bill) {
        billId = bill.id || '';
        previousReading = parseFloat(bill.previousReading) || 0;
        currentReading = bill.currentReading || '';
        consumedKwh = parseFloat(bill.consumedKwh) || (parseFloat(currentReading) - previousReading);
        amountPerKwh = parseFloat(reading.amountPerKwh || bill.amountPerKwh) || 0;
        total = parseFloat(bill.amount) || (consumedKwh * amountPerKwh);
      }
    }

    totalConsumedKwh += consumedKwh;
    grandTotal += total;

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>
          <div class="form-floating me-2 col-12 mt-3">
            <input type="hidden" class="renter-id" value="${renterId}" />
            <input type="hidden" class="bill-id" value="${billId}" />
            <input type="text" class="form-control current-reading" data-renter-id="${renterId}" value="${currentReading}" placeholder="" required="required"/>
            <label>Current Reading *</label>
          </div>
        </td>
        <td>${previousReading}</td>
        <td class="consumed-kwh">${consumedKwh}</td>
        <td class="amount-per-kwh">PHP ${formatPHP(amountPerKwh)}</td>
        <td class="total">PHP ${formatPHP(total)}</td>
      </tr>
    `);
  });

  $tbody.append(`
    <tr class="fw-bolder">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td class="total-consumed-kwh">${totalConsumedKwh}</td>
      <td></td>
      <td class="grand-total">PHP ${formatPHP(grandTotal)}</td>
    </tr>
  `);

  recalculateModifyElectricBillTable();
}

// Recalculate all rows and summary when readings or total bill change
function recalculateModifyElectricBillTable() {
  let totalConsumedKwh = 0;
  $('#modalModifyElectricBill .consumed-kwh').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      totalConsumedKwh += parseFloat($(this).text()) || 0;
    }
  });
  $('.total-consumed-kwh').text(totalConsumedKwh);

  const totalBill = parseFloat($('#modify-billings-electric-total-bill').val().replace(/,/g, '')) || 0;
  const amountPerKwh = totalConsumedKwh > 0 ? (totalBill / totalConsumedKwh) : 0;

  $('#modalModifyElectricBill .amount-per-kwh').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      $(this).text('PHP ' + formatPHP(amountPerKwh));
    }
  });

  $('#modalModifyElectricBill .consumed-kwh').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      const consumed = parseFloat($(this).text()) || 0;
      const total = consumed * amountPerKwh;
      $(this).closest('tr').find('.total').text('PHP ' + formatPHP(total));
    }
  });

  let grandTotal = 0;
  $('#modalModifyElectricBill .total').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      grandTotal += parseFloat($(this).text().replace('PHP ', '').replace(/,/g, '')) || 0;
    }
  });
  $('.grand-total').text('PHP ' + formatPHP(grandTotal));
}

$(document).on('input', '#modalModifyElectricBill .current-reading', function() {
  const $row = $(this).closest('tr');
  const currentReading = parseFloat($(this).val()) || 0;
  const previousReading = parseFloat($row.find('td:eq(3)').text()) || 0;
  const consumedKwh = currentReading - previousReading;
  $row.find('.consumed-kwh').text(consumedKwh);

  recalculateModifyElectricBillTable();
});

$('#modify-billings-electric-total-bill').on('input', function() {
  recalculateModifyElectricBillTable();
});

$('#modify-electric-bill-month-due').on('change', function() {
  populateModifyElectricBillTable($(this).val());
});

$('#button-modify-electric').on("click", function () {
  const monthDue = $("#modify-electric-bill-month-due").val().trim();
  const totalBill = $("#modify-billings-electric-total-bill").val().trim();

  if (!monthDue || !totalBill) {
    return showError("All required fields must be filled.", "#error-box-modify-electric", "#error-text-modify-electric");
  }
  if (!isDecimal(totalBill)) {
    return showError("Total bill must be decimal.", "#error-box-modify-electric", "#error-text-modify-electric");
  }

  let isValid = true;
  let errorMessage = "";

  $('#form-modify-electric').find('input[type="hidden"]').remove();

  // Add reading ID as hidden input
  $('<input>').attr({
    type: 'hidden',
    name: 'readingId',
    value: $('#form-modify-electric').data('readingId')
  }).appendTo('#form-modify-electric');

  $('<input>').attr({
    type: 'hidden',
    name: 'monthDue',
    value: monthDue
  }).appendTo('#form-modify-electric');

  $('<input>').attr({
    type: 'hidden',
    name: 'totalBill',
    value: totalBill.replace(/,/g, '')
  }).appendTo('#form-modify-electric');

  $('#modalModifyElectricBill table.custom-table tbody tr').each(function() {
    if ($(this).hasClass('fw-bolder')) return;

    const $row = $(this);
    const renterId = $row.find('input.renter-id').val();
    const billId = $row.find('input.bill-id').val();
    const roomNo = $row.find('td:eq(0)').text().trim();
    const currentReading = $row.find('.current-reading').val();
    const previousReading = $row.find('td:eq(3)').text().trim();
    const consumedKwh = $row.find('.consumed-kwh').text().trim();
    const amountPerKwh = $row.find('.amount-per-kwh').text().replace('PHP ', '').replace(/,/g, '').trim();
    const total = $row.find('.total').text().replace('PHP ', '').replace(/,/g, '').trim();

    if (currentReading === "") {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} is required.`;
      $row.find('.current-reading').focus();
      return false;
    }
    if (!isNumber(currentReading)) {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} must be a valid number.`;
      $row.find('.current-reading').focus();
      return false;
    }
    if (parseFloat(currentReading) <= parseFloat(previousReading)) {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} must be greater than previous reading (${previousReading}).`;
      $row.find('.current-reading').focus();
      return false;
    }

    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][billId]`,
      value: billId
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][roomNo]`,
      value: roomNo
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][currentReading]`,
      value: currentReading
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][previousReading]`,
      value: previousReading
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][consumedKwh]`,
      value: consumedKwh
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][amountPerKwh]`,
      value: amountPerKwh
    }).appendTo('#form-modify-electric');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][total]`,
      value: total
    }).appendTo('#form-modify-electric');
  });

  if (!isValid) {
    return showError(errorMessage, "#error-box-modify-electric", "#error-text-modify-electric");
  }

  $('#modalModifyElectricBill').modal('hide');
  $('#modalModifyElectricBillConfirmation').modal('show');
});

$('#button-confirm-modify-electric').on("click", function (e) {
  e.preventDefault();
  $('#form-modify-electric')[0].submit();
  clearModifyElectricBillForm();
});

function clearModifyElectricBillForm() {
  $('#modify-electric-bill-month-due').val('');
  $('#modify-billings-electric-total-bill').val('');
  $('#error-box-modify-electric').hide();
  $('#error-text-modify-electric').text('');
  const $tbody = $('#modalModifyElectricBill table.custom-table tbody');
  $tbody.find('tr').each(function() {
    if ($(this).hasClass('fw-bolder')) {
      $(this).find('.total-consumed-kwh').text('0');
      $(this).find('.grand-total').text('0');
    } else {
      $(this).find('.current-reading').val('');
      $(this).find('.consumed-kwh').text('0');
      $(this).find('.amount-per-kwh').text('0');
      $(this).find('.total').text('0');
    }
  });
  $('#form-modify-electric').find('input[type="hidden"]').remove();
}








// When the modal opens, set due date and populate table and total bill
$('#modalModifyWaterBill').on('shown.bs.modal', function() {
  const monthStr = $('#water-bill-month-due').val();
  if (!monthStr) return;

  let dueDate = '';
  if (utilityBillsMap['Water']) {
    const reading = utilityBillsMap['Water'].readings.find(r => 
      r.dueDate && r.dueDate.startsWith(monthStr));
    if (reading) {
      dueDate = reading.dueDate;
    }
  }

  $('#modify-water-bill-month-due').val(dueDate);
  populateModifyWaterBillTable(dueDate);
});

// Populates the Modify Water Bill table
function populateModifyWaterBillTable(dueDate) {
  const $tbody = $('#modalModifyWaterBill table.custom-table tbody');
  $tbody.empty();

  let totalConsumedM3 = 0;
  let grandTotal = 0;
  let totalBillFromXML = 0;
  let readingId = '';

  let reading = null;
  if (utilityBillsMap['Water']) {
    reading = utilityBillsMap['Water'].readings.find(r => r.dueDate && r.dueDate === dueDate);
    if (reading) {
      readingId = reading.id || '';
      totalBillFromXML = parseFloat(reading.totalBill) || 0;
    }
  }

  // Store reading ID for form submission
  $('#form-modify-water').data('readingId', readingId);

  $('#modify-billings-water-total-bill').val(totalBillFromXML ? formatPHP(totalBillFromXML) : '');

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return;
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    let bill = null, previousReading = 0, currentReading = '', consumedM3 = 0, amountPerM3 = 0, total = 0, billId = '';
    if (reading && reading.bills) {
      bill = reading.bills.find(b => String(b.renterId) === String(renterId));
      if (bill) {
        billId = bill.id || '';
        previousReading = parseFloat(bill.previousReading) || 0;
        currentReading = bill.currentReading || '';
        consumedM3 = parseFloat(bill.consumedM3) || (parseFloat(currentReading) - previousReading);
        amountPerM3 = parseFloat(reading.amountPerM3 || bill.amountPerM3) || 0;
        total = parseFloat(bill.amount) || (consumedM3 * amountPerM3);
      }
    }

    totalConsumedM3 += consumedM3;
    grandTotal += total;

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>
          <div class="form-floating me-2 col-12 mt-3">
            <input type="hidden" class="renter-id" value="${renterId}" />
            <input type="hidden" class="bill-id" value="${billId}" />
            <input type="text" class="form-control current-reading" data-renter-id="${renterId}" value="${currentReading}" placeholder="" required="required"/>
            <label>Current Reading *</label>
          </div>
        </td>
        <td>${previousReading}</td>
        <td class="consumed-m3">${consumedM3}</td>
        <td class="amount-per-m3">PHP ${formatPHP(amountPerM3)}</td>
        <td class="total">PHP ${formatPHP(total)}</td>
      </tr>
    `);
  });

  $tbody.append(`
    <tr class="fw-bolder">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td class="total-consumed-m3">${totalConsumedM3}</td>
      <td></td>
      <td class="grand-total">PHP ${formatPHP(grandTotal)}</td>
    </tr>
  `);

  recalculateModifyWaterBillTable();
}

// Recalculate all rows and summary when readings or total bill change
function recalculateModifyWaterBillTable() {
  let totalConsumedM3 = 0;
  $('#modalModifyWaterBill .consumed-m3').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      totalConsumedM3 += parseFloat($(this).text()) || 0;
    }
  });
  $('.total-consumed-m3').text(totalConsumedM3);

  const totalBill = parseFloat($('#modify-billings-water-total-bill').val().replace(/,/g, '')) || 0;
  const amountPerM3 = totalConsumedM3 > 0 ? (totalBill / totalConsumedM3) : 0;

  $('#modalModifyWaterBill .amount-per-m3').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      $(this).text('PHP ' + formatPHP(amountPerM3));
    }
  });

  $('#modalModifyWaterBill .consumed-m3').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      const consumed = parseFloat($(this).text()) || 0;
      const total = consumed * amountPerM3;
      $(this).closest('tr').find('.total').text('PHP ' + formatPHP(total));
    }
  });

  let grandTotal = 0;
  $('#modalModifyWaterBill .total').each(function() {
    if (!$(this).closest('tr').hasClass('fw-bolder')) {
      grandTotal += parseFloat($(this).text().replace('PHP ', '').replace(/,/g, '')) || 0;
    }
  });
  $('.grand-total').text('PHP ' + formatPHP(grandTotal));
}

$(document).on('input', '#modalModifyWaterBill .current-reading', function() {
  const $row = $(this).closest('tr');
  const currentReading = parseFloat($(this).val()) || 0;
  const previousReading = parseFloat($row.find('td:eq(3)').text()) || 0;
  const consumedM3 = currentReading - previousReading;
  $row.find('.consumed-m3').text(consumedM3);

  recalculateModifyWaterBillTable();
});

$('#modify-billings-water-total-bill').on('input', function() {
  recalculateModifyWaterBillTable();
});

$('#modify-water-bill-month-due').on('change', function() {
  populateModifyWaterBillTable($(this).val());
});

$('#button-modify-water').on("click", function () {
  const monthDue = $("#modify-water-bill-month-due").val().trim();
  const totalBill = $("#modify-billings-water-total-bill").val().trim();

  if (!monthDue || !totalBill) {
    return showError("All required fields must be filled.", "#error-box-modify-water", "#error-text-modify-water");
  }
  if (!isDecimal(totalBill)) {
    return showError("Total bill must be decimal.", "#error-box-modify-water", "#error-text-modify-water");
  }

  let isValid = true;
  let errorMessage = "";

  $('#form-modify-water').find('input[type="hidden"]').remove();

  // Add reading ID as hidden input
  $('<input>').attr({
    type: 'hidden',
    name: 'readingId',
    value: $('#form-modify-water').data('readingId')
  }).appendTo('#form-modify-water');

  $('<input>').attr({
    type: 'hidden',
    name: 'monthDue',
    value: monthDue
  }).appendTo('#form-modify-water');

  $('<input>').attr({
    type: 'hidden',
    name: 'totalBill',
    value: totalBill.replace(/,/g, '')
  }).appendTo('#form-modify-water');

  let rentersCount = 0;
  let rentersDebug = {};

  $('#modalModifyWaterBill table.custom-table tbody tr').each(function() {
    if ($(this).hasClass('fw-bolder')) return;

    const $row = $(this);
    const renterId = $row.find('input.renter-id').val();
    const billId = $row.find('input.bill-id').val();
    const roomNo = $row.find('td:eq(0)').text().trim();
    const currentReading = $row.find('.current-reading').val();
    const previousReading = $row.find('td:eq(3)').text().trim();
    const consumedM3 = $row.find('.consumed-m3').text().trim();
    const amountPerM3 = $row.find('.amount-per-m3').text().replace('PHP ', '').replace(/,/g, '').trim();
    const total = $row.find('.total').text().replace('PHP ', '').replace(/,/g, '').trim();

    // Debug: log each renter's data
    rentersDebug[renterId] = {
      billId, roomNo, currentReading, previousReading, consumedM3, amountPerM3, total
    };

    if (currentReading === "") {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} is required.`;
      $row.find('.current-reading').focus();
      return false;
    }
    if (!isNumber(currentReading)) {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} must be a valid number.`;
      $row.find('.current-reading').focus();
      return false;
    }
    if (parseFloat(currentReading) <= parseFloat(previousReading)) {
      isValid = false;
      errorMessage = `Current reading for ${$row.find('td:eq(1)').text().trim()} must be greater than previous reading (${previousReading}).`;
      $row.find('.current-reading').focus();
      return false;
    }

    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][billId]`,
      value: billId
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][roomNo]`,
      value: roomNo
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][currentReading]`,
      value: currentReading
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][previousReading]`,
      value: previousReading
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][consumedM3]`,
      value: consumedM3
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][amountPerM3]`,
      value: amountPerM3
    }).appendTo('#form-modify-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][total]`,
      value: total
    }).appendTo('#form-modify-water');
    rentersCount++;
  });

  console.log("Renters appended:", rentersCount, rentersDebug);

  // Log all hidden inputs that will be submitted
  let formData = $('#form-modify-water').serializeArray();
  console.log("Form data to submit:", formData);

  if (!isValid) {
    return showError(errorMessage, "#error-box-modify-water", "#error-text-modify-water");
  }

  $('#modalModifyWaterBill').modal('hide');
  $('#modalModifyWaterBillConfirmation').modal('show');
});

$('#button-confirm-modify-water').on("click", function (e) {
  e.preventDefault();
  // Log final data before submit
  let formData = $('#form-modify-water').serializeArray();
  console.log("Submitting form data:", formData);
  $('#form-modify-water')[0].submit();
  clearModifyWaterBillForm();
});

function clearModifyWaterBillForm() {
  $('#modify-water-bill-month-due').val('');
  $('#modify-billings-water-total-bill').val('');
  $('#error-box-modify-water').hide();
  $('#error-text-modify-water').text('');
  const $tbody = $('#modalModifyWaterBill table.custom-table tbody');
  $tbody.find('tr').each(function() {
    if ($(this).hasClass('fw-bolder')) {
      $(this).find('.total-consumed-m3').text('0');
      $(this).find('.grand-total').text('0');
    } else {
      $(this).find('.current-reading').val('');
      $(this).find('.consumed-m3').text('0');
      $(this).find('.amount-per-m3').text('0');
      $(this).find('.total').text('0');
    }
  });
  $('#form-modify-water').find('input[type="hidden"]').remove();
}









// --- Populate Water Bill Table ---
function populateWaterBillTable() {
  const $tbody = $('#modalGenerateWaterBill table.custom-table tbody');
  $tbody.empty();

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return;
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    const today = new Date();
    const currentMonth = today.toISOString().slice(0, 7);

    let previousReading = getPreviousWaterReading(renterId, currentMonth);

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>
          <div class="form-floating me-2 col-12 mt-3">
            <input type="hidden" class="renter-id" value="${renterId}" />
            <input type="text" class="form-control current-reading" data-renter-id="${renterId}" placeholder="" required="required"/>
            <label>Current Reading *</label>
          </div>
        </td>
        <td>${previousReading}</td>
        <td class="consumed-m3">0</td>
        <td class="amount-per-m3">0</td>
        <td class="total">0</td>
      </tr>
    `);
  });

  // Add summary row
  $tbody.append(`
    <tr class="fw-bolder">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td class="total-consumed-m3">0</td>
      <td></td>
      <td class="grand-total">0</td>
    </tr>
  `);
}

// --- Show Modal and Populate Table ---
$('#modalGenerateWaterBill').on('shown.bs.modal', function() {
  populateWaterBillTable();
});

// --- Handle Current Reading Input ---
$(document).on('input', '#modalGenerateWaterBill .current-reading', function() {
  const $row = $(this).closest('tr');
  const currentReading = parseFloat($(this).val()) || 0;
  const previousReading = parseFloat($row.find('td:eq(3)').text()) || 0;
  const consumedM3 = currentReading - previousReading;
  $row.find('.consumed-m3').text(consumedM3);

  // Get amount per m3 (from total bill / total consumed m3)
  const totalBill = parseFloat($('#add-billings-water-total-bill').val()) || 0;
  let totalConsumedM3 = 0;
  $('#modalGenerateWaterBill .consumed-m3').each(function() {
    totalConsumedM3 += parseFloat($(this).text()) || 0;
  });
  $('.total-consumed-m3').text(totalConsumedM3);

  const amountPerM3 = totalConsumedM3 > 0 ? (totalBill / totalConsumedM3) : 0;
  $('.amount-per-m3').text('PHP ' + formatPHP(amountPerM3));

  // Compute total for each renter
  $('#modalGenerateWaterBill .consumed-m3').each(function() {
    const consumed = parseFloat($(this).text()) || 0;
    const total = consumed * amountPerM3;
    $(this).closest('tr').find('.total').text('PHP ' + formatPHP(total));
  });

  // Update grand total
  let grandTotal = 0;
  $('#modalGenerateWaterBill .total').each(function() {
    grandTotal += parseFloat($(this).text().replace('PHP ', '').replace(/,/g, '')) || 0;
  });
  $('.grand-total').text('PHP ' + formatPHP(grandTotal));
});

// --- Recompute on Total Bill Change ---
$('#add-billings-water-total-bill').on('input', function() {
  $('#modalGenerateWaterBill .current-reading').trigger('input');
});

// --- Generate Water Bill Button ---
$('#button-generate-water').on("click", function () {
  const monthDue = $("#generate-water-bill-month-due").val().trim();
  const totalBill = $("#add-billings-water-total-bill").val().trim();

  if (!monthDue || !totalBill) {
    return showError("All required fields must be filled.", "#error-box-generate-water", "#error-text-generate-water");
  }
  if (!isDecimal(totalBill)) {
    return showError("Total bill must be decimal.", "#error-box-generate-water", "#error-text-generate-water");
  }

  let isValid = true;
  let errorMessage = "";

  // Clear previous hidden inputs
  $('#form-generate-water').find('input[type="hidden"]').remove();

  // Validate each row
  $('#modalGenerateWaterBill table.custom-table tbody tr').each(function() {
    if ($(this).hasClass('fw-bolder')) return;

    const $row = $(this);
    const renterName = $row.find('td:eq(1)').text().trim();
    const $currentReadingInput = $row.find('.current-reading');
    const currentReadingStr = $currentReadingInput.val().trim();
    const previousReadingStr = $row.find('td:eq(3)').text().trim();

    if (currentReadingStr === "") {
      isValid = false;
      errorMessage = `Current reading for ${renterName} is required.`;
      $currentReadingInput.focus();
      return false;
    }
    if (!isNumber(currentReadingStr)) {
      isValid = false;
      errorMessage = `Current reading for ${renterName} must be a valid number.`;
      $currentReadingInput.focus();
      return false;
    }
    const currentReading = parseFloat(currentReadingStr);
    const previousReading = parseFloat(previousReadingStr);
    if (currentReading <= previousReading) {
      isValid = false;
      errorMessage = `Current reading for ${renterName} must be greater than previous reading (${previousReading}).`;
      $currentReadingInput.focus();
      return false;
    }
  });

  if (!isValid) {
    return showError(errorMessage, "#error-box-generate-water", "#error-text-generate-water");
  }

  // Append hidden inputs for each renter
  $('#form-generate-water').find('input[type="hidden"]').remove();
  $('#modalGenerateWaterBill table.custom-table tbody tr').each(function() {
    if ($(this).hasClass('fw-bolder')) return;

    const $row = $(this);
    const renterId = $row.find('input.renter-id').val();
    const roomNo = $row.find('td:eq(0)').text().trim();
    const currentReading = $row.find('.current-reading').val();
    const previousReading = $row.find('td:eq(3)').text().trim();
    const consumedM3 = $row.find('.consumed-m3').text().trim();
    const amountPerM3 = $row.find('.amount-per-m3').text().replace('PHP ', '').trim();
    const total = $row.find('.total').text().replace('PHP ', '').trim();

    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][roomNo]`,
      value: roomNo
    }).appendTo('#form-generate-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][currentReading]`,
      value: currentReading
    }).appendTo('#form-generate-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][previousReading]`,
      value: previousReading
    }).appendTo('#form-generate-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][consumedM3]`,
      value: consumedM3
    }).appendTo('#form-generate-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][amountPerM3]`,
      value: amountPerM3
    }).appendTo('#form-generate-water');
    $('<input>').attr({
      type: 'hidden',
      name: `renters[${renterId}][total]`,
      value: total
    }).appendTo('#form-generate-water');
  });

  // Optionally show confirmation modal or submit
  $('#modalGenerateWaterBill').modal('hide');
  $('#modalGenerateWaterBillConfirmation').modal('show');
});

// --- Confirm Generate Water Bill ---
$('#button-confirm-generate-water').on("click", function (e) {
  e.preventDefault();
  $('#form-generate-water')[0].submit();
  clearGenerateWaterBillForm();
});

// --- Clear Water Bill Form ---
function clearGenerateWaterBillForm() {
  $('#generate-water-bill-month-due').val('');
  $('#add-billings-water-total-bill').val('');
  $('#error-box-generate-water').hide();
  $('#error-text-generate-water').text('');
  const $tbody = $('#modalGenerateWaterBill table.custom-table tbody');
  $tbody.find('tr').each(function() {
    if ($(this).hasClass('fw-bolder')) {
      $(this).find('.total-consumed-m3').text('0');
      $(this).find('.grand-total').text('0');
    } else {
      $(this).find('.current-reading').val('');
      $(this).find('.consumed-m3').text('0');
      $(this).find('.amount-per-m3').text('0');
      $(this).find('.total').text('0');
    }
  });
  $('#form-generate-water').find('input[type="hidden"]').remove();
}























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


function populateElectricBillAllocation(monthYear) {
  const $tbody = $('#electric-bill-allocation tbody');
  $tbody.empty();

  let totalConsumedKwh = 0;
  let grandTotal = 0;

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return;
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    // Find the reading for this renter for the given monthYear (YYYY-MM)
    // Assuming you have a data structure similar to utilityBillsMap['Electricity'].readings
    let readingForMonth = null;
    if (utilityBillsMap['Electricity']) {
      readingForMonth = utilityBillsMap['Electricity'].readings.find(r =>
        r.dueDate && r.dueDate.startsWith(monthYear) &&
        r.bills.some(bill => String(bill.renterId) === String(renterId))
      );
    }
    if (!readingForMonth) return; // No reading for this month for this renter

    // Get the bill for this renter
    const bill = readingForMonth.bills.find(b => String(b.renterId) === String(renterId));
    if (!bill) return;

    const currentReading = parseFloat(bill.currentReading) || 0;
    const previousReading = getPreviousElectricReading(renterId, monthYear);
    const consumedKwh = parseFloat(bill.consumedKwh) || (currentReading - previousReading);
    const amountPerKwh = parseFloat(bill.amountPerKwh) || 0;
    const total = parseFloat(bill.amount) || (consumedKwh * amountPerKwh);

    totalConsumedKwh += consumedKwh;
    grandTotal += total;

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>${currentReading}</td>
        <td>${previousReading}</td>
        <td>${consumedKwh}</td>
        <td>PHP ${formatPHP(amountPerKwh)}</td>
        <td>PHP ${formatPHP(total)}</td>
      </tr>
    `);
  });

  // Add footer row
  $tbody.append(`
    <tr class="fw-bolder">
      <td colspan="4"></td>
      <td>${totalConsumedKwh}</td>
      <td></td>
      <td>PHP ${formatPHP(grandTotal)}</td>
    </tr>
  `);
}

// Example usage: populate for May 2025
$(document).ready(function() {
  const today = new Date();
  const yearMonth = today.toISOString().slice(0, 7); // e.g. "2025-05"
  $('#electric-bill-month-due').val(yearMonth); // Set date input to current month
  populateElectricBillAllocation(yearMonth);

  // Optional: add event listener to update table when month changes
  $('#electric-bill-month-due').on('change', function() {
    const selectedMonth = $(this).val();
    populateElectricBillAllocation(selectedMonth);
  });
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

  function populateWaterBillAllocation(monthYear) {
  const $tbody = $('#water-bill-allocation tbody');
  $tbody.empty();

  let totalConsumedM3 = 0;
  let grandTotal = 0;

  Object.keys(renterDataMap).forEach(renterId => {
    const renter = renterDataMap[renterId];
    if (!renter.unitId) return;
    if (renter.status && renter.status.toLowerCase() === 'archived') return;

    const room = roomsDataMap[renter.unitId] || {};
    const roomNo = room.roomNo || '';
    const fullName = [renter.firstName, renter.middleName, renter.surname, renter.extension].filter(Boolean).join(' ');

    // Find the water reading for this renter for the selected month
    let readingForMonth = null;
    if (utilityBillsMap['Water']) {
      readingForMonth = utilityBillsMap['Water'].readings.find(r =>
        r.dueDate && r.dueDate.startsWith(monthYear) &&
        r.bills.some(bill => String(bill.renterId) === String(renterId))
      );
    }
    if (!readingForMonth) return; // No water reading for this renter for this month

    const bill = readingForMonth.bills.find(b => String(b.renterId) === String(renterId));
    if (!bill) return;

    const currentReading = parseFloat(bill.currentReading) || 0;
    const previousReading = getPreviousWaterReading(renterId, monthYear);
    const consumedM3 = parseFloat(bill.consumedM3) || (currentReading - previousReading);
    const amountPerM3 = parseFloat(bill.amountPerM3) || 0;
    const total = parseFloat(bill.amount) || (consumedM3 * amountPerM3);

    totalConsumedM3 += consumedM3;
    grandTotal += total;

    $tbody.append(`
      <tr>
        <td>${roomNo}</td>
        <td>${fullName}</td>
        <td>${currentReading}</td>
        <td>${previousReading}</td>
        <td>${consumedM3}</td>
        <td>PHP ${formatPHP(amountPerM3)}</td>
        <td>PHP ${formatPHP(total)}</td>
      </tr>
    `);
  });

  // Add footer row with totals
  $tbody.append(`
    <tr class="fw-bolder">
      <td colspan="4"></td>
      <td>${totalConsumedM3}</td>
      <td></td>
      <td>PHP ${formatPHP(grandTotal)}</td>
    </tr>
  `);
}

// Usage example: populate on page load and on month change
$(document).ready(function() {
  const today = new Date();
  const yearMonth = today.toISOString().slice(0, 7); // e.g. "2025-05"
  $('#water-bill-month-due').val(yearMonth);
  populateWaterBillAllocation(yearMonth);

  $('#water-bill-month-due').on('change', function() {
    const selectedMonth = $(this).val();
    populateWaterBillAllocation(selectedMonth);
  });
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

  // When modal is shown, populate fields from XML
  $('#modalModifyElectricMetadata').on('shown.bs.modal', function() {
  const utility = utilityBillsMap['Electricity'];
  if (utility) {
    $('#modify-electric-customer-account-name').val(utility.accountName || '');
    $('#modify-electric-customer-account-number').val(utility.accountNumber || '');
    $('#modify-electric-meter-number').val(utility.meterNumber || '');
    $('#modify-electric-address').val(utility.address || '');
  } else {
    console.error('Electric utility not found in utilityBillsMap.');
  }
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

    // Fill hidden form for PHP
    $("#hidden-modify-electric-account-name").val(customerAccountName);
    $("#hidden-modify-electric-account-number").val(customerAccountNumber);
    $("#hidden-modify-electric-meter-number").val(meterNumber);
    $("#hidden-modify-electric-address").val(address);

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

  $('#modalModifyWaterMetadata').on('shown.bs.modal', function() {
  const utility = utilityBillsMap['Water'];
  if (utility) {
    $('#modify-water-customer-account-name').val(utility.accountName || '');
    $('#modify-water-customer-account-number').val(utility.accountNumber || '');
    $('#modify-water-meter-number').val(utility.meterNumber || '');
    $('#modify-water-address').val(utility.address || '');
  }
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

    // Fill hidden form for PHP
    $("#hidden-modify-water-account-name").val(customerAccountName);
    $("#hidden-modify-water-account-number").val(customerAccountNumber);
    $("#hidden-modify-water-meter-number").val(meterNumber);
    $("#hidden-modify-water-address").val(address);

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
    if ($("#record-payment-electric-checkbox").is(":checked")) paymentTypes.push("Electricity");
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

    // Set bill_id, reading_id, overdue_bill_ids using paymentContext class
    if (paymentContext.isOverduePayment) {
        $("#hidden-record-bill-id").val("");
        $("#hidden-record-reading-id").val("");
        $("#hidden-record-overdue-bill-ids").val(paymentContext.overdueBillIdsArray.join(","));
    } else {
        $("#hidden-record-bill-id").val(paymentContext.selectedBillId || "");
        $("#hidden-record-reading-id").val(paymentContext.selectedReadingId || "");
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
  


  // $('#button-login').on("click", function () {
  //   // Collect input values
  //   const email = $("#modify-electric-customer-account-name").val().trim();
  //   const password = $("#modify-electric-customer-account-number").val().trim();

  //   // VALIDATIONS
  //   if (!email || !password) {
  //     return showError("All required fields must be filled.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  //   }    

  //   // Check for whitespace-only inputs
  //   if ([email, password].some(isWhitespaceOnly)) {
  //     return showError("Whitespace-only fields are not allowed.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  //   }
  
  //   // Length validation
  //   if ([email, password].some(f => exceedsLengthLimit(f))) {
  //     return showError("One or more fields exceed the length limit.", "#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  //   }

  //   // Fill confirmation modal
  //   $("#confirm-modify-electric-metadata-customer-account-name").text(customerAccountName);
  //   $("#confirm-modify-electric-metadata-customer-account-number").text(customerAccountNumber);
  //   $("#confirm-modify-electric-metadata-meter-number").text(meterNumber);
  //   $("#confirm-modify-electric-metadata-address").text(address);

  //   // TODO: PROCESS
  //   $('#modalModifyElectricMetadata').modal('hide');
  //   $('#modalModifyElectricMetadataConfirmation').modal('show');
  //   hideError("#error-box-modify-electric-metadata", "#error-text-electric-metadata");
  // });














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







function sendNotification(renterID) {
  const renterEmail = renterDataMap[renterID]?.email;
  if (!renterEmail) {
    console.error("No email found for renterID:", renterID);
    return;
  }
  const templateParams = {
    to_email: renterEmail,
  };
  emailjs.send('service_8p2cgis', 'template_1glsq68', templateParams)
    .then(function(response) {
      console.log('Notification email sent!', response.status, response.text);
    }, function(error) {
      console.error('Failed to send notification email:', error);
    });
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
      window.location.href = "caretaker-dashboard.xml";
      break;
    case "caretaker":
      window.location.href = "caretaker-dashboard.xml";
      break;
    case "renter":
      window.location.href = "renter-dashboard.xml";
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

function isDecimal(input) {
  return /^[+-]?\d+(\.\d+)?$/.test(input);
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

function calculateTotalPendingTasks() {
  let count = 0;

  // Assuming tasksMap is an object with taskId keys and task objects as values
  for (const taskId in tasksMap) {
    if (tasksMap.hasOwnProperty(taskId)) {
      const task = tasksMap[taskId];
      // Consider tasks with status 'Pending' or 'Overdue' as pending
      if (task.status && (task.status.toLowerCase() === 'pending' || task.status.toLowerCase() === 'overdue')) {
        count++;
      }
    }
  }

  return count;
}


function isDateInCurrentWeek(dateStr) {
  const today = new Date();
  const date = new Date(dateStr);

  // Get Monday of the current week
  const dayOfWeek = today.getDay(); // Sunday = 0, Monday = 1, ..., Saturday = 6
  const diffToMonday = (dayOfWeek + 6) % 7; // Days since Monday
  const monday = new Date(today);
  monday.setDate(today.getDate() - diffToMonday);
  monday.setHours(0, 0, 0, 0);

  // Get Sunday of the current week
  const sunday = new Date(monday);
  sunday.setDate(monday.getDate() + 6);
  sunday.setHours(23, 59, 59, 999);

  return date >= monday && date <= sunday;
}

function calculateTotalUrgentTasks() {
  let count = 0;

  for (const taskId in tasksMap) {
    if (tasksMap.hasOwnProperty(taskId)) {
      const task = tasksMap[taskId];
      if (task.dueDate && isDateInCurrentWeek(task.dueDate)) {
        count++;
      }
    }
  }

  return count;
}

function isDateBeforeToday(dateStr) {
  const today = new Date();
  today.setHours(0, 0, 0, 0); // Normalize to start of today
  const date = new Date(dateStr);
  date.setHours(0, 0, 0, 0);
  return date < today;
}

function calculateTotalOverdueTasks() {
  let count = 0;

  for (const taskId in tasksMap) {
    if (tasksMap.hasOwnProperty(taskId)) {
      const task = tasksMap[taskId];
      if (task.dueDate && isDateBeforeToday(task.dueDate)) {
        // Optionally, exclude completed tasks if your data has a status
        if (!task.status || task.status.toLowerCase() !== 'completed') {
          count++;
        }
      }
    }
  }

  return count;
}


function updateOnTimePaymentRateByStatus(utilityBillsMap, rentBillsMap) {
  let totalPayments = 0;
  let onTimePayments = 0;

  function isPaidOnTime(status) {
    return status && status.toLowerCase() === 'paid';
  }

  for (const billId in rentBillsMap) {
    if (rentBillsMap.hasOwnProperty(billId)) {
      const bill = rentBillsMap[billId];
      totalPayments++;
      if (isPaidOnTime(bill.status)) onTimePayments++;
    }
  }

  for (const utilityType in utilityBillsMap) {
    if (utilityBillsMap.hasOwnProperty(utilityType)) {
      const utility = utilityBillsMap[utilityType];
      const readings = utility.readings || [];

      readings.forEach(reading => {
        const bills = reading.bills || [];
        bills.forEach(bill => {
          totalPayments++;
          if (isPaidOnTime(bill.status)) onTimePayments++;
        });
      });
    }
  }

  let rate = 0;
  if (totalPayments > 0) {
    rate = (onTimePayments / totalPayments) * 100;
  }

  const formattedRate = rate.toFixed(2) + '%';
  $('#on-time-payment-rate').text(formattedRate);
}



function updateCollectionRate(utilityBillsMap, rentBillsMap) {
  let totalPaid = 0;
  let totalDue = 0;

  // Sum rent bills
  for (const billId in rentBillsMap) {
    if (rentBillsMap.hasOwnProperty(billId)) {
      const bill = rentBillsMap[billId];

      const amount = parseFloat(bill.amount.replace(/[^0-9.-]+/g, '')) || 0;
      const overpaid = parseFloat(bill.overpaid.replace(/[^0-9.-]+/g, '')) || 0;
      const debt = parseFloat(bill.debt.replace(/[^0-9.-]+/g, '')) || 0;

      totalDue += amount + debt;
      totalPaid += amount + overpaid;
    }
  }

  // Sum utility bills
  for (const utilityType in utilityBillsMap) {
    if (utilityBillsMap.hasOwnProperty(utilityType)) {
      const utility = utilityBillsMap[utilityType];
      const readings = utility.readings || [];

      readings.forEach(reading => {
        const bills = reading.bills || [];
        bills.forEach(bill => {
          const amount = parseFloat(bill.amount.replace(/[^0-9.-]+/g, '')) || 0;
          const overpaid = parseFloat(bill.overpaid.replace(/[^0-9.-]+/g, '')) || 0;
          const debt = parseFloat(bill.debt.replace(/[^0-9.-]+/g, '')) || 0;

          totalDue += amount + debt;
          totalPaid += amount + overpaid;
        });
      });
    }
  }

  let rate = 0;
  if (totalDue > 0) {
    rate = (totalPaid / totalDue) * 100;
  }

  const formattedRate = rate.toFixed(2) + '%';
  $('#collection-rate').text(formattedRate);
}


// function updateTotalCurrentBillsDueThisMonth(utilityBillsMap, rentBillsMap) {
//   let total = 0;

//   // Helper function to check if a date is in the current month and year
//   function isDueThisMonth(dateStr) {
//     if (!dateStr) return false;
//     const dueDate = new Date(dateStr);
//     if (isNaN(dueDate)) return false;

//     const now = new Date();
//     return dueDate.getFullYear() === now.getFullYear() && dueDate.getMonth() === now.getMonth();
//   }

//   // Sum rent bills due this month
//   for (const id in rentBillsMap) {
//     if (rentBillsMap.hasOwnProperty(id)) {
//       const bill = rentBillsMap[id];
//       if (isDueThisMonth(bill.dueDate)) {
//         const amount = parseFloat(bill.amount.replace(/[^0-9.-]+/g, '')) || 0;
//         total += amount;
//       }
//     }
//   }

//   // Sum utility bills due this month
//   for (const utilityType in utilityBillsMap) {
//     if (utilityBillsMap.hasOwnProperty(utilityType)) {
//       const utility = utilityBillsMap[utilityType];
//       const readings = utility.readings || [];

//       readings.forEach(reading => {
//         // Check reading dueDate if needed, but usually bills have their own dueDate
//         const bills = reading.bills || [];
//         bills.forEach(bill => {
//           if (isDueThisMonth(bill.dueDate)) {
//             const amount = parseFloat(bill.amount.replace(/[^0-9.-]+/g, '')) || 0;
//             total += amount;
//           }
//         });
//       });
//     }
//   }

//   $('#total-current-bills').text("PHP " + formatPHP(total));
// }



function updateNumberOfInactiveAccounts(usersMap) {
  let inactiveCount = 0;
  for (const userId in usersMap) {
    if (usersMap.hasOwnProperty(userId)) {
      const user = usersMap[userId];
      if (user.status && user.status.toLowerCase() === 'archived') {
        inactiveCount++;
      }
    }
  }
  $('#total-inactive-accounts').text(inactiveCount);
}


function formatPHP(amount) {
  return Number(amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function updateTotalPayments(paymentsMap) {
  let total = 0;

  for (const paymentId in paymentsMap) {
    if (paymentsMap.hasOwnProperty(paymentId)) {
      const payment = paymentsMap[paymentId];
      // Parse amount as float, handle commas or currency symbols if needed
      let amount = payment.amount;

      // If amount is string with commas or currency, clean it:
      if (typeof amount === 'string') {
        amount = amount.replace(/[^0-9.-]+/g, ''); // Remove non-numeric chars except dot and minus
      }

      amount = parseFloat(amount);
      if (!isNaN(amount)) {
        total += amount;
      }
    }
  }

  // // Format total as currency string, e.g., PHP 7,208.28
  // const formattedTotal = total.toLocaleString('en-PH', {
  //   style: 'currency',
  //   currency: 'PHP',
  //   minimumFractionDigits: 2,
  //   maximumFractionDigits: 2
  // });

  $('#total-payments').text("PHP " + formatPHP(total));
}

function updateOverdueRenters(renterDataMap) {
  let overdueCount = 0;

  for (const renterId in renterDataMap) {
    if (renterDataMap.hasOwnProperty(renterId)) {
      const renter = renterDataMap[renterId];
      if (renter.isOverdue === true) {
        overdueCount++;
      }
    }
  }

  $('#total-overdue-renters').text(overdueCount);
}


function updateNumberOfRenterAccounts(usersMap) {
  let renterCount = 0;
  for (const userId in usersMap) {
    if (usersMap.hasOwnProperty(userId)) {
      const user = usersMap[userId];
      if (user.userRole && user.userRole.toLowerCase() === 'renter') {
        renterCount++;
      }
    }
  }
  $('#total-renter-accounts').text(renterCount);
}


function updateNumberOfCaretakerAccounts(usersMap) {
  let caretakerCount = 0;
  for (const userId in usersMap) {
    if (usersMap.hasOwnProperty(userId)) {
      const user = usersMap[userId];
      if (user.userRole && user.userRole.toLowerCase() === 'caretaker') {
        caretakerCount++;
      }
    }
  }
  $('#total-caretaker-accounts').text(caretakerCount);
}


function calculateNumberOfAccounts(users) {
  // users is an array of user objects
  return users.length;
}

function updateTotalRenters(usersMap) {
  let renterCount = 0;
  for (const userId in usersMap) {
    if (usersMap.hasOwnProperty(userId)) {
      const user = usersMap[userId];
      if (user.userRole && user.userRole.toLowerCase() === 'renter') {
        renterCount++;
      }
    }
  }
  $('#total-renters').text(renterCount);
}


function updateTotalRenters(renterDataMap) {
  const totalRenters = Object.keys(renterDataMap).length;
  $('#total-renters-accounts').text(totalRenters);
}



function calculateTotalCompletedTasks() {
  let count = 0;

  for (const taskId in tasksMap) {
    if (tasksMap.hasOwnProperty(taskId)) {
      const task = tasksMap[taskId];
      if (task.status && task.status.toLowerCase() === 'completed') {
        count++;
      }
    }
  }

  return count;
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

