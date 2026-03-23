package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView loginForm() {
        return new ModelAndView("login");
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ModelAndView login(@RequestParam("email") final String email,
                              final HttpServletRequest request) {
        if (email == null || email.trim().isEmpty()) {
            final ModelAndView mav = new ModelAndView("login");
            mav.addObject("error", "Ingresá tu email.");
            return mav;
        }

        final User user = userService.findOrCreate(email.trim());
        request.getSession().setAttribute("currentUser", user);
        return new ModelAndView("redirect:/");
    }

    @RequestMapping(value = "/logout")
    public ModelAndView logout(final HttpServletRequest request) {
        request.getSession().invalidate();
        return new ModelAndView("redirect:/");
    }
}
