<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<title>ShopStop - One Stop Shopping, For You!</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="./css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
      }
    </style>
    <link href="./css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
</head>
<body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="/test/">ShopStop</a>
          <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              <% if (session.getAttribute("username") != null) {
            	  out.print("Logged in as " + session.getAttribute("username") + " ");
    		      out.print("<a href='/test/signout.jsp'>Log out?</a>");
                }else
                  out.print("<a href='/test/signin.jsp'>Log in</a>");
    		%>
            </p>
            <ul class="nav">
              <li><a href="/test/">Home</a></li>
              <li><a href="/test/signup.jsp">Sign Up</a></li>
              <% if (session.getAttribute("role").equals("Owner")){ %>
              <li><a href="/test/category.jsp">Categories</a></li>
              <li><a href="/test/analytics.jsp">Analytics</a></li>
              <% } %>
              <li><a href="/test/products.jsp">Products</a></li>
              <li class="active"><a href="/test/shoppingcart.jsp">My Cart</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

<%@ page import="java.util.*, org.json.simple.JSONObject" %>
<%@ page import="java.io.*,javax.servlet.*,java.text.*" %>
<%@ page import="java.sql.*"%>
    <% try {
       Calendar calendar = Calendar.getInstance();
       calendar.getTime();
       if (application.getAttribute("day") == null)
    	   application.setAttribute("day", calendar.get(Calendar.DAY_OF_MONTH));
       int today = calendar.get(Calendar.DAY_OF_MONTH);
       boolean newDay = ((Integer) application.getAttribute("day")) != today;
        Connection conn = null;
		Statement statement = null;
		ResultSet rs = null;
        Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
		statement = conn.createStatement();
		rs = statement.executeQuery("select * from cse135.CATEGORY ORDER BY CATEGORY.nam");
       
       String [] states = {"","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID",
   			"IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY",
   			"OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"};
       
       if(application.getAttribute("purchases") == null || newDay) {
			application.setAttribute("purchases", new LinkedHashMap<String, LinkedHashMap<String, Integer> >());
			LinkedHashMap<String, LinkedHashMap<String, Integer> > purchases
        	= (LinkedHashMap<String, LinkedHashMap<String, Integer> >) application.getAttribute("purchases");
			while (rs.next()) {
				LinkedHashMap<String, Integer> thing = new LinkedHashMap<String, Integer>();
				for (int i = 1; i < states.length; i++)
					thing.put(states[i], 0);
				purchases.put(rs.getString("nam"), thing);
			}
			application.setAttribute("purchases", purchases);
       }
       
        LinkedHashMap<String, LinkedHashMap<String, Integer> > purchases
        	= (LinkedHashMap<String, LinkedHashMap<String, Integer> >) application.getAttribute("purchases");
    %>
<%@ page import="java.sql.*"%>
			<script type="text/javascript">
			function makeRequest() {
				$.ajax({
					  type: 'POST',
					  url: "processSales.jsp",
					  success:function(result){
						  var elements = $.parseJSON(result);
						  for(var i = 0; i < elements.length; i++) {
			                  var p = elements[i]['category'];
							  var s = elements[i]['state'];
							  var a = elements[i]['amount'];
							  $('#' + p + '_' + s).html("$" + a);
			              }
					  },
					  error:function(){
						  alert("error huehuehuehuehuehheuhuehue");
					  }
					});
			}
			setInterval("makeRequest()", 2000 );
			</script>
			<table border="1">
			<tr>
				<% for (int i = 0; i < states.length; i++)
					out.write("<th>" + states[i] + "</th>");
				%>
			</tr>
				<% Iterator it = purchases.entrySet().iterator();
                	while(it.hasNext()){
	                    Map.Entry pair = (Map.Entry)it.next();
	                    String categoryName = (String) pair.getKey();
	        			Iterator it2 = ((LinkedHashMap<String, Integer>) pair.getValue()).entrySet().iterator();
	        			String row = "<tr id='" + categoryName + "'><td>" + categoryName + "</td>";
	        			while (it2.hasNext()) {
	        				Map.Entry pair2 = (Map.Entry) it2.next();
	   						String id = pair.getKey() + "_" + pair2.getKey();
	                        row += "<td id='" + id + "'>$" + pair2.getValue() + "</td>";
	        			}
	        			row += "</tr>";
	        			out.write(row);
               		}%>
			</table>
<%
	rs.close();
	statement.close();
	conn.close();
    } catch (Exception e) {
	System.out.println (e);
	System.out.println ("also you suck?!!?!?!?!??!");
} %>
</body>
</html>