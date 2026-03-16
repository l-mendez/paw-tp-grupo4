package ar.edu.itba.paw.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public ModelAndView home() {
        final ModelAndView mav = new ModelAndView("index");

        // Text component parameters
        mav.addObject("heading", "Welcome to PAW");
        mav.addObject("subtitle", "A Spring MVC Web Application");
        mav.addObject("bodyText", "This page demonstrates all custom tag components.");

        // Button component parameters
        mav.addObject("buttonText", "Click Me");
        mav.addObject("buttonSize", "lg");

        // Toast component parameters
        mav.addObject("toastTitle", "Notification");
        mav.addObject("toastMessage", "Application loaded successfully!");

        return mav;
    }
}
