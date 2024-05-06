package org.example.SpringController;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.Base64;

@Controller
public class TestController {
    @RequestMapping("/index")
    public String index(){
        return "index";
    }
    @RequestMapping("/Filter")
    public  String shell(){
        return "Filter";
    }
    @RequestMapping("/Listener")
    public  String listener(){
        return "Listener";
    }
    @RequestMapping("/Servlet")
    public  String Servlet(){
        return "Servlet";
    }
    @RequestMapping("/unserialize")
    public String unserialize(@RequestParam String exp) throws IOException, ClassNotFoundException {
            byte[] b = Base64.getDecoder().decode(exp);
            ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(b));
            ois.readObject();
            return "ok";
    }

}
