document.addEventListener('turbolinks:load', () => {
    const topUpUtcElement = document.getElementById("topup-utc-time")
    if (!topUpUtcElement) {
        return
      }
    const topUpUtcTime = topUpUtcElement.getAttribute("data-utc-time");
    const userTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const userLocalTime = new Date(topUpUtcTime.toLocaleString("auto", { timeZone: userTimeZone }));

    const hours = userLocalTime.getHours();
    const minutes = userLocalTime.getMinutes();
    const formattedTime = hours.toString().padStart(2, "0") + ":" + minutes.toString().padStart(2, "0");

    document.getElementById("formatted-time").textContent = formattedTime;
})
