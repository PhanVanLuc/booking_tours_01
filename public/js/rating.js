function rate(tourId, stars) {
  const data = {
    tourId,
    stars
  };
  fetch("/ratings", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  })
    .then((res) => res.json())
    .then((data) => {
      if(!data.success) {
        document.querySelector("#error").innerHTML = data.errors.join(",");
        return;
      }
      const { avg, stars } = data;
      
      document.querySelectorAll(".rate").forEach((elm) => {
        if (+elm.dataset.stars <= stars) 
          {elm.classList.add("text-warning");}
        else 
          {elm.classList.remove("text-warning");}
      });
    })
    .catch((err) => {
      window.location.href = "/login";
    });
}
document.querySelectorAll(".rate").forEach((elm) => {
  elm.addEventListener("click", function () {
    rate(document.querySelector("input#tour_id").value, elm.dataset.stars);
  });
});