/**
 * Site pessoal — Victor Rizzotto
 * Comportamentos: tema, menu mobile, link ativo no menu e animação de entrada.
 * Tudo progressivo: o site funciona bem sem JavaScript.
 */
(function () {
  "use strict";

  var root = document.documentElement;

  /* --- Tema claro / escuro --------------------------------------------- */
  var themeToggle = document.querySelector(".theme-toggle");

  function systemTheme() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function applyTheme(theme) {
    root.dataset.theme = theme;
    if (themeToggle) {
      themeToggle.setAttribute(
        "aria-label",
        theme === "dark" ? "Mudar para tema claro" : "Mudar para tema escuro"
      );
    }
    var meta = document.querySelector('meta[name="theme-color"]:not([media])');
    if (meta) {
      meta.setAttribute("content", theme === "dark" ? "#0b0e14" : "#fbfcfe");
    }
  }

  if (themeToggle) {
    applyTheme(root.dataset.theme || systemTheme());

    themeToggle.addEventListener("click", function () {
      var next = root.dataset.theme === "dark" ? "light" : "dark";
      applyTheme(next);
      try {
        localStorage.setItem("theme", next);
      } catch (e) {}
    });
  }

  /* --- Menu mobile ------------------------------------------------------ */
  var navToggle = document.querySelector(".nav-toggle");
  var navList = document.getElementById("menu-principal");

  function closeMenu() {
    if (!navToggle || !navList) return;
    navToggle.setAttribute("aria-expanded", "false");
    navList.classList.remove("is-open");
  }

  if (navToggle && navList) {
    navToggle.addEventListener("click", function () {
      var open = navToggle.getAttribute("aria-expanded") === "true";
      navToggle.setAttribute("aria-expanded", String(!open));
      navList.classList.toggle("is-open", !open);
    });

    navList.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeMenu();
    });

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") closeMenu();
    });

    window.addEventListener("resize", function () {
      if (window.innerWidth > 736) closeMenu();
    });
  }

  /* --- Link ativo conforme a seção visível ------------------------------ */
  var navLinks = Array.prototype.slice.call(document.querySelectorAll('.nav-list a[href^="#"]'));
  var sections = navLinks
    .map(function (link) {
      return document.querySelector(link.getAttribute("href"));
    })
    .filter(Boolean);

  if ("IntersectionObserver" in window && sections.length) {
    var spy = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          navLinks.forEach(function (link) {
            var active = link.getAttribute("href") === "#" + entry.target.id;
            if (active) {
              link.setAttribute("aria-current", "true");
            } else {
              link.removeAttribute("aria-current");
            }
          });
        });
      },
      { rootMargin: "-45% 0px -50% 0px", threshold: 0 }
    );

    sections.forEach(function (section) {
      spy.observe(section);
    });
  }

  /* --- Animação de entrada ---------------------------------------------- */
  var prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var animated = document.querySelectorAll(".section-head, .card, .prose, .contact-list");

  if (!prefersReduced && "IntersectionObserver" in window && animated.length) {
    var revealer = new IntersectionObserver(
      function (entries, observer) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        });
      },
      { threshold: 0.05, rootMargin: "0px 0px -40px 0px" }
    );

    animated.forEach(function (el, index) {
      el.classList.add("reveal");
      el.style.transitionDelay = Math.min(index * 45, 220) + "ms";
      revealer.observe(el);
    });
  }

  /* --- Ano no rodapé ---------------------------------------------------- */
  var year = document.getElementById("ano");
  if (year) year.textContent = String(new Date().getFullYear());
})();
