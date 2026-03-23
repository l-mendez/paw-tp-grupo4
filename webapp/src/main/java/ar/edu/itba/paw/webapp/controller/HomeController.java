package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.models.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public ModelAndView home(final HttpSession session) {
        final ModelAndView mav = new ModelAndView("index");

        final User currentUser = (User) session.getAttribute("currentUser");
        mav.addObject("currentUser", currentUser);

        return mav;
    }
}
