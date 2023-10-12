document.addEventListener('turbolinks:load', () => {
  if (window.innerWidth > 1024) {
    return
  }
  const navbarBurgers = document.querySelector('.navbar-burger')
  const navbar = document.querySelector('.navbar')
  const footer = document.querySelector('.navbar-footer')
  const hideSpeedDown = 15
  const showSpeedUp = 25
  var lastScrollPisition = 0
  var isClicked = false
  var isBottomed = false

  window.addEventListener('scroll', () => {
    var scrollTop = window.scrollY || document.documentElement.scrollTop
    var scrollSpeedDown = scrollTop - lastScrollPisition
    var scrollSpeedUp = lastScrollPisition - scrollTop

    // go down
    if ((scrollTop > lastScrollPisition && scrollSpeedDown > hideSpeedDown && !isClicked) || isBottomed) {
      navbar.style.transform = 'translateY(-100%)'
      footer.style.opacity = '0.4'
      // go up
    } else if (scrollTop < lastScrollPisition && scrollSpeedUp > showSpeedUp) {
      navbar.style.transform = 'translateY(0)'
      footer.style.opacity = '1'
      // at the top
    } else if (scrollTop === 0) {
      navbar.style.transform = 'translateY(0)'
      footer.style.opacity = '1'
    }
    isBottomed = false
    // at the bottom
    if ((window.innerHeight + scrollTop) >= document.body.scrollHeight) {
      navbar.style.transform = 'translateY(0)'
      footer.style.opacity = '1'
      isBottomed = true
    }
    lastScrollPisition = scrollTop <= 0 ? 0 : scrollTop
    isClicked = false
  }, false)

  navbarBurgers.addEventListener('click', () => {
    isClicked = true
    const target = document.getElementById(navbarBurgers.dataset.target)

    navbarBurgers.classList.toggle('is-active')
    target.classList.toggle('is-active')
  })
})
