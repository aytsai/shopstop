<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
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

@media ( max-width : 980px) {
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

</head>

<body>

	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container-fluid">
				<button type="button" class="btn btn-navbar" data-toggle="collapse"
					data-target=".nav-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="brand" href="/test/">ShopStop</a>
				<div class="nav-collapse collapse">
					<p class="navbar-text pull-right">
						<% if (session.getAttribute("username") != null) {
            	  out.print("Logged in as " + session.getAttribute("username") + " ");
    		      out.print("<a href='/test/signout.jsp'>Log out?</a>");
                } else
                  out.print("<a href='/test/signin.jsp'>Log in</a>");
    		%>
					</p>
					<ul class="nav">
						<li><a href="/test/">Home</a></li>
						<li><a href="/test/signup.jsp">Sign Up</a></li>
						<% if (session.getAttribute("username") != null){ %>
						<% if (session.getAttribute("role").equals("Owner")){ %>
						<li><a href="/test/category.jsp">Categories</a></li>
						<li class="active"><a href="/test/analytics.jsp">Analytics</a></li>
						<% } %>
						<li><a href="/test/products.jsp">Products</a></li>
						<% if (session.getAttribute("role").equals("Customer")){ %>
						<li><a href="/test/browse.jsp">Browse</a></li>
						<% } %>
						<% if (session.getAttribute("role").equals("Customer")){ %>
						<li><a href="/test/shoppingcart.jsp">My Cart</a></li>
						<% } %>
						<% } %>
					</ul>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>

	<%@ page import="java.sql.*"%>
	<%@ page import="java.util.ArrayList"%>
	<%
		Connection conn = null;
		Statement statement = null;
		Statement statement2 = null;
		Statement statement3 = null;
		Statement statement4 = null;
		Statement statement5 = null;
		Statement statement6 = null;
		
		String seasonState = "";
		String ageState = "";
		String categoryState = "";
		String locationState = "";
		
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		ResultSet rs5 = null;
		ResultSet rs6 = null;
		String link, link2 = "";
		String filter; //Filter Query!!
		String thingamabobber = "";
		Integer c, r, o, p, q;
		Integer rowcount, colcount;
		Integer minAge = 0, maxAge = 0;
		try {
			String action = request.getParameter("action");
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
			statement2 = conn.createStatement();
			statement3 = conn.createStatement();
			statement5 = conn.createStatement();
			statement6 = conn.createStatement();
			
			// get the row/col page here
			session.setAttribute("row", null);
			session.setAttribute("col", null);
			if (request.getParameter("row") != null) session.setAttribute("row", request.getParameter("row"));
			if (request.getParameter("col") != null) session.setAttribute("col", request.getParameter("col"));
			
			if (request.getParameter("col") == null) o = 0;
			else o = Integer.parseInt(request.getParameter("col").toString());
			if (request.getParameter("col") == null) q = 0;
			else q = Integer.parseInt(request.getParameter("col").toString());
			if (request.getParameter("row") == null) p = 0;
			else p = Integer.parseInt(request.getParameter("row").toString());
			String st = "SELECT PRODUCTS.name, PRODUCTS.id, PRODUCTS.price, PRODUCTS.cat " +
                    "FROM PURCHASES LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
			String stb = "GROUP BY PRODUCTS.id ORDER BY SUM(amount) DESC LIMIT 10 " +
							"OFFSET ";
			// default display
			String st2, st2b;
			if (session.getAttribute("ty") == null || session.getAttribute("ty").equals("cust")) {
				st2 = "SELECT USERS.* " +
                      "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
          		      "LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
          		st2b = "GROUP BY USERS.id ORDER BY SUM(amount*price) DESC LIMIT 10 " +
                       "OFFSET ";
			}
			else {
				
				st2 = "SELECT USERS.* " +
			          "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
		        	  "LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
		        st2b = "GROUP BY USERS.sta ORDER BY USERS.sta LIMIT 10 " +
		               "OFFSET ";
			}
			
			if (action != null && action.equals("table")) {
				session.setAttribute("ty", request.getParameter("ty"));
				if ((request.getParameter("ty")).equals("stas")) {
					st2 = "SELECT USERS.* " +
			              "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
		                  "LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
		            st2b = "GROUP BY USERS.sta ORDER BY USERS.sta LIMIT 10 " +
		                   "OFFSET ";
				}
				else {
					st2 = "SELECT USERS.* " +
		                  "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
	              	      "LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
	              	st2b = "GROUP BY USERS.id ORDER BY SUM(amount*price) DESC LIMIT 10 " +
	                       "OFFSET ";
				}
			}
			
			/***************************************************/			
			/***************************************************/
			/* ***************** FILTER ********************** */
			/***************************************************/
			/***************************************************/
			
			//I wish we were using JDK 7, because String switch statements are possible.
			
			filter = "";
			
			if (request.getParameter("age") != null) 
			{
				ArrayList<String> l = new ArrayList<String>(); //Dump commands here
				ageState = request.getParameter("age");
				//Doing age
				String age = request.getParameter("age");
				int temp = -1;
				if(age.equals("zero"))
					temp = 0;
				else if(age.equals("ten"))
					temp = 10;
				else if(age.equals("twenty"))
					temp = 20;
				else if(age.equals("thirty"))
					temp = 30;
				else if(age.equals("forty"))
					temp = 40;
				else if(age.equals("fifty"))
					temp = 50;
				else if(age.equals("sixty"))
					temp = 60;
				else if(age.equals("seventy"))
					temp = 70;
				else if(age.equals("eighty"))
					temp = 80;
				else if(age.equals("ninety"))
					temp = 90;
				
				if(temp >= 0)
					l.add(String.format("USERS.age >= %d AND USERS.age <= %d", temp, temp+10));
					
				
				//doing United States State
				if(!request.getParameter("sta").equals("ALL")){
					locationState = request.getParameter("sta");
					l.add(String.format("USERS.sta = '%s'", request.getParameter("sta")));
				}
				
				//doing categories
			   if(!request.getParameter("category").equals("allcats")) {
				   categoryState = request.getParameter("category");
				   rs6 = statement6.executeQuery("SELECT CATEGORY.id FROM CATEGORY where CATEGORY.nam = '" + request.getParameter("category") + "'");
				   rs6.next();
				   thingamabobber = "WHERE PRODUCTS.cat = '" + rs6.getString("id") + "' ";
			   }
				
				//Doing Quarter
				if(!request.getParameter("quarter").equals("entire")){
					l.add(String.format("PURCHASES.season = '%s'", request.getParameter("quarter")));	
					seasonState = request.getParameter("quarter");
				}
				
				//Assemble bits
				if(!l.isEmpty())
				{
					filter += " WHERE " + l.get(0) + " ";
					for(int i = 1; i < l.size(); i++)
						filter += " AND " + l.get(i);
				}
				
				link2 = "&age=" + request.getParameter("age") +
						"&sta=" + request.getParameter("sta") +
						"&category=" + request.getParameter("category") +
						"&quarter=" + request.getParameter("quarter");
			}

			rs = statement.executeQuery(st + thingamabobber + stb + o*10);
		
			if (session.getAttribute("username") != null) {
			%>

	<form action="analytics.jsp" method="POST">
		<input type="hidden" name="action" value="table" /> Type: <select
			name="ty">
			<option value="cust"<% if(session.getAttribute("ty") == null || session.getAttribute("ty").equals("cust")) out.println(" selected='selected'"); %> >Customers</option>
			<option value="stas"<% if(!(session.getAttribute("ty") == null || session.getAttribute("ty").equals("cust"))) out.println(" selected='selected'"); %>>States</option>
		</select>
		<td><input type="submit" value="Regenerate" /></td>
	</form>
	<form action="analytics.jsp" method="POST">
		<input type="hidden" name="action" value="filter" /> Ages: <select
			name="age">
			<option value="allages" >All Ages</option>
			<option value="zero" <%if (ageState.equals("zero")) out.println("selected='selected'"); %>>0 - 9</option>
			<option value="ten" <%if (ageState.equals("ten")) out.println("selected='selected'"); %>>10 - 19</option>
			<option value="twenty" <%if (ageState.equals("twenty")) out.println("selected='selected'"); %>>20 - 29</option>
			<option value="thirty" <%if (ageState.equals("thirty")) out.println("selected='selected'"); %>>30 - 39</option>
			<option value="forty" <%if (ageState.equals("forty")) out.println("selected='selected'"); %>>40 - 49</option>
			<option value="fifty" <%if (ageState.equals("fifty")) out.println("selected='selected'"); %>>50 - 59</option>
			<option value="sixty" <%if (ageState.equals("sixty")) out.println("selected='selected'"); %>>60 - 69</option>
			<option value="seventy" <%if (ageState.equals("seventy")) out.println("selected='selected'"); %>>70 - 79</option>
			<option value="eighty" <%if (ageState.equals("eighty")) out.println("selected='selected'"); %>>80 - 89</option>
			<option value="ninety" <%if (ageState.equals("ninety")) out.println("selected='selected'"); %>>90 - 99</option>
		</select> States: <select name="sta">
			<option value="ALL">All States</option>
			<option value="AL" <%if (locationState.equals("AL")) out.println("selected='selected'"); %>>Alabama</option>
			<option value="AK" <%if (locationState.equals("AK")) out.println("selected='selected'"); %>>Alaska</option>
			<option value="AZ" <%if (locationState.equals("AZ")) out.println("selected='selected'"); %>>Arizona</option>
			<option value="AR" <%if (locationState.equals("AR")) out.println("selected='selected'"); %>>Arkansas</option>
			<option value="CA" <%if (locationState.equals("CA")) out.println("selected='selected'"); %>>California</option>
			<option value="CO" <%if (locationState.equals("CO")) out.println("selected='selected'"); %>>Colorado</option>
			<option value="CT" <%if (locationState.equals("CT")) out.println("selected='selected'"); %>>Connecticut</option>
			<option value="DE" <%if (locationState.equals("DE")) out.println("selected='selected'"); %>>Delaware</option>
			<option value="DC" <%if (locationState.equals("DC")) out.println("selected='selected'"); %>>District Of Columbia</option>
			<option value="FL" <%if (locationState.equals("FL")) out.println("selected='selected'"); %>>Florida</option>
			<option value="GA" <%if (locationState.equals("GA")) out.println("selected='selected'"); %>>Georgia</option>
			<option value="HI" <%if (locationState.equals("HI")) out.println("selected='selected'"); %>>Hawaii</option>
			<option value="ID" <%if (locationState.equals("ID")) out.println("selected='selected'"); %>>Idaho</option>
			<option value="IL" <%if (locationState.equals("IL")) out.println("selected='selected'"); %>>Illinois</option>
			<option value="IN" <%if (locationState.equals("IN")) out.println("selected='selected'"); %>>Indiana</option>
			<option value="IA" <%if (locationState.equals("IA")) out.println("selected='selected'"); %>>Iowa</option>
			<option value="KS" <%if (locationState.equals("KS")) out.println("selected='selected'"); %>>Kansas</option>
			<option value="KY" <%if (locationState.equals("KY")) out.println("selected='selected'"); %>>Kentucky</option>
			<option value="LA" <%if (locationState.equals("LA")) out.println("selected='selected'"); %>>Louisiana</option>
			<option value="ME" <%if (locationState.equals("ME")) out.println("selected='selected'"); %>>Maine</option>
			<option value="MD" <%if (locationState.equals("MD")) out.println("selected='selected'"); %>>Maryland</option>
			<option value="MA" <%if (locationState.equals("MA")) out.println("selected='selected'"); %>>Massachusetts</option>
			<option value="MI" <%if (locationState.equals("MI")) out.println("selected='selected'"); %>>Michigan</option>
			<option value="MN" <%if (locationState.equals("MN")) out.println("selected='selected'"); %>>Minnesota</option>
			<option value="MS" <%if (locationState.equals("MS")) out.println("selected='selected'"); %>>Mississippi</option>
			<option value="MO" <%if (locationState.equals("MO")) out.println("selected='selected'"); %>>Missouri</option>
			<option value="MT" <%if (locationState.equals("MT")) out.println("selected='selected'"); %>>Montana</option>
			<option value="NE" <%if (locationState.equals("NE")) out.println("selected='selected'"); %>>Nebraska</option>
			<option value="NV" <%if (locationState.equals("NV")) out.println("selected='selected'"); %>>Nevada</option>
			<option value="NH" <%if (locationState.equals("NH")) out.println("selected='selected'"); %>>New Hampshire</option>
			<option value="NJ" <%if (locationState.equals("NJ")) out.println("selected='selected'"); %>>New Jersey</option>
			<option value="NM" <%if (locationState.equals("NM")) out.println("selected='selected'"); %>>New Mexico</option>
			<option value="NY" <%if (locationState.equals("NY")) out.println("selected='selected'"); %>>New York</option>
			<option value="NC" <%if (locationState.equals("NC")) out.println("selected='selected'"); %>>North Carolina</option>
			<option value="ND" <%if (locationState.equals("ND")) out.println("selected='selected'"); %>>North Dakota</option>
			<option value="OH" <%if (locationState.equals("OH")) out.println("selected='selected'"); %>>Ohio</option>
			<option value="OK" <%if (locationState.equals("OK")) out.println("selected='selected'"); %>>Oklahoma</option>
			<option value="OR" <%if (locationState.equals("OR")) out.println("selected='selected'"); %>>Oregon</option>
			<option value="PA" <%if (locationState.equals("PA")) out.println("selected='selected'"); %>>Pennsylvania</option>
			<option value="RI" <%if (locationState.equals("RI")) out.println("selected='selected'"); %>>Rhode Island</option>
			<option value="SC" <%if (locationState.equals("SC")) out.println("selected='selected'"); %>>South Carolina</option>
			<option value="SD" <%if (locationState.equals("SD")) out.println("selected='selected'"); %>>South Dakota</option>
			<option value="TN" <%if (locationState.equals("TN")) out.println("selected='selected'"); %>>Tennessee</option>
			<option value="TX" <%if (locationState.equals("TX")) out.println("selected='selected'"); %>>Texas</option>
			<option value="UT" <%if (locationState.equals("UT")) out.println("selected='selected'"); %>>Utah</option>
			<option value="VT" <%if (locationState.equals("VT")) out.println("selected='selected'"); %>>Vermont</option>
			<option value="VA" <%if (locationState.equals("VA")) out.println("selected='selected'"); %>>Virginia</option>
			<option value="WA" <%if (locationState.equals("WA")) out.println("selected='selected'"); %>>Washington</option>
			<option value="WV" <%if (locationState.equals("WV")) out.println("selected='selected'"); %>>West Virginia</option>
			<option value="WI" <%if (locationState.equals("WI")) out.println("selected='selected'"); %>>Wisconsin</option>
			<option value="WY" <%if (locationState.equals("WY")) out.println("selected='selected'"); %>>Wyoming</option>
		</select> Categories: <select name="category">
			<option value="allcats">All Categories</option>
			<% rs5 = statement5.executeQuery("SELECT * FROM CATEGORY");
	                       while (rs5.next()) {
	                    	    if ((rs5.getString("nam")).equals(categoryState)) out.println ("<option selected='selected' value=\"" + rs5.getString("nam") + "\">" + rs5.getString("nam") + "</option>");
	                    	    else out.println ("<option value=\"" + rs5.getString("nam") + "\">" + rs5.getString("nam") + "</option>");
	                       } %>
		</select> Quarters: <select name="quarter">
			<option value="entire" <%if (seasonState.equals("")) out.println("selected='selected'"); %>>Full Year</option>
			<option value="Spring" <%if (seasonState.equals("Spring")) out.println("selected='selected'"); %>>Spring</option>
			<option value="Summer" <%if (seasonState.equals("Summer")) out.println("selected='selected'"); %>>Summer</option>
			<option value="Fall" <%if (seasonState.equals("Fall")) out.println("selected='selected'"); %>>Fall</option>
			<option value="Winter" <%if (seasonState.equals("Winter")) out.println("selected='selected'"); %>>Winter</option>
		</select>


		<td><input type="submit" value="Filter" /></td>
	</form>
	<p>This table only shows the items that have been purchased before.</p>

	<!-- 				   -->
	<!-- 				   -->
	<!--  BEGIN TABLE AREA -->
	<!-- 				   -->
	<!-- 				   -->


	<div class="container">
		<div class="row">
			<div class="span10">
				<table class="table table-bordered table-hover">
					<thead>
						<tr>
							<th></th>
							<%
				while (rs.next()) {
					%>
							<th><%= rs.getString("name") %></th>
							<%
            	}%>
						</tr>
					</thead>
					<tbody>
						<%
              	if (request.getParameter("row") == null) o = 0;
  				else o = Integer.parseInt(request.getParameter("row").toString());
						
              	rs2 = statement2.executeQuery(st2 + filter + st2b + o*10);
                while (rs2.next()) {
	                	if ((rs2.getString("role")).equals("Customer")) {
	                		if (session.getAttribute("ty") == null || (session.getAttribute("ty").toString()).equals("cust")) { 
			                	rs = statement.executeQuery(st + thingamabobber + stb + o*10); %>
						<tr>
							<td><b>Name: <%= rs2.getString("nam") %></b><br> Age: <%= rs2.getString("age") %><br>
								State: <%= rs2.getString("sta") %><br></td>
							<%
			                	while (rs.next()) {
			                		rs3 = statement3.executeQuery("SELECT COUNT(PURCHASES.amount), SUM(PURCHASES.amount)" +
			                									  "FROM PURCHASES WHERE PURCHASES.customer = '"
			                				                      + rs2.getString("id") + "' AND PURCHASES.product = '"
			                				                      + rs.getString("id") + "' GROUP BY PURCHASES.product");
			                		if (rs3.next()) { %>
							<td>Orders: <%= rs3.getString(1) %><br> Value: $<%= rs3.getInt(2)*rs.getInt("price") %></td>
							<%
			                		}
			                		else {%><td>No records found.</td>
							<%}
			                	}
			                	%>
						</tr>
						<%
			                } // decide which table
			                else {
			                	rs = statement.executeQuery(st + thingamabobber + stb + o*10); %>
						<tr>
							<td><b>State: <%= rs2.getString("sta") %></b><br></td>
							<%
			                	while (rs.next()) {
			                		rs3 = statement3.executeQuery("SELECT COUNT(PURCHASES.amount), SUM(PURCHASES.amount)" +
			                									  "FROM PURCHASES WHERE PURCHASES.customer = '"
			                				                      + rs2.getString("id") + "' AND PURCHASES.product = '"
			                				                      + rs.getString("id") + "' GROUP BY PURCHASES.product");
			                		if (rs3.next()) { %>
							<td>Orders: <%= rs3.getString(1) %><br> Value: $<%= rs3.getInt(2)*rs.getInt("price") %></td>
							<%
			                		}
			                		else {%><td>No records found.</td>
							<%}
			                	}
			                	%>
						</tr>
						<%
			                } // decide which table
		                }
                	}
                 	%>
					</tbody>
				</table>
			</div>
			<div class="span2">
				<br> <br> <br> <br> <br> <br> <br>
				<br>
				<% if (session.getAttribute("row") == null || session.getAttribute("row").equals("0")) r = 0;
			   else r = Integer.parseInt(session.getAttribute("row").toString()) - 1;
			   link = "analytics.jsp?row=" + r;
		       if (session.getAttribute("col") != null) link += "&col=" + session.getAttribute("col");
		       if (session.getAttribute("row") != null && !(session.getAttribute("row").equals("0")))
		    	   out.println ("<a href=" + link + link2 + ">Prev</a><br>");
		    %>
				<br> <br> Showing rows
				<%=p*10 + 1%>
				-
				<%=(p+1)*10%>
				<br> <br>
				<% if (session.getAttribute("row") == null) r = 1;
			   else r = Integer.parseInt(session.getAttribute("row").toString()) + 1;
			   link = "analytics.jsp?row=" + r;
		       if (session.getAttribute("col") != null) link += "&col=" + session.getAttribute("col");
		       statement4 = conn.createStatement();
		       rs4 = statement4.executeQuery(st2 + filter + st2b + (p+1)*10);
		       if (rs4.next()) out.println ("<a href=" + link + link2 + ">Next</a><br>");
		    %>



			</div>
			<div class="row">
				<div class="span1 offset3">
					<% if (session.getAttribute("col") == null || session.getAttribute("col").equals("0")) c = 0;
			   else c = Integer.parseInt(session.getAttribute("col").toString()) - 1;
			   link = "analytics.jsp?col=" + c;
		       if (session.getAttribute("row") != null) link += "&row=" + session.getAttribute("row");
		       if (session.getAttribute("col") != null && !(session.getAttribute("col").equals("0")))
		    	   out.println ("<a href=" + link + link2 + ">Prev</a><br>");
		    %>
				</div>
				<div class="span2">
					Showing cols
					<%=q*10 + 1%>
					-
					<%=(q+1)*10%>
				</div>
				<div class="span1 offset1">
					<% if (session.getAttribute("col") == null) c = 1;
			   else c = Integer.parseInt(session.getAttribute("col").toString()) + 1;
			   link = "analytics.jsp?col=" + c;
		       if (session.getAttribute("row") != null) link += "&row=" + session.getAttribute("row");
		       statement4 = conn.createStatement();
		       rs4 = statement4.executeQuery(st + thingamabobber + stb + (q+1)*10);
		       if (rs4.next()) out.println ("<a href=" + link + link2 + ">Next</a><br>");
		    %>
				</div>
			</div>
		</div>

		<hr>

		<footer>
			<p>&copy; ShopStop 2013</p>
		</footer>

	</div>
	<!--/container-->

	<%
			}
		   	else {
		   		out.println ("Please log in.");
		   	}
			rs.close();
			statement.close();
			conn.close();
		} catch (SQLException e) {
			System.out.println (e);
			System.out.println ("also you suck???!!?");
		}
	%>
</body>
</html>