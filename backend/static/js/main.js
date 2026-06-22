// =====================================================================
// EMPLOYEE DATABASE MANAGEMENT SYSTEM — main.js
// =====================================================================

document.addEventListener("DOMContentLoaded", function () {

  // Auto-dismiss flash messages after 4 seconds
  const flashes = document.querySelectorAll(".flash");
  flashes.forEach((flash) => {
    setTimeout(() => {
      flash.style.transition = "opacity 0.4s ease";
      flash.style.opacity = "0";
      setTimeout(() => flash.remove(), 400);
    }, 4000);
  });

  // Live-update topbar date badge
  const dateBadge = document.querySelector(".date-badge");
  if (dateBadge) {
    const now = new Date();
    const options = { weekday: "long", year: "numeric", month: "long", day: "numeric" };
    dateBadge.textContent = now.toLocaleDateString("en-IN", options);
  }

  // Simple client-side confirm helper reused by inline forms
  window.confirmAction = function (message) {
    return window.confirm(message || "Are you sure?");
  };
});
