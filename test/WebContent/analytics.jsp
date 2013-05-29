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
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		ResultSet rs5 = null;
		String link;
		String filter; //Filter Query!!
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
			String st = "SELECT PRODUCTS.name, PRODUCTS.id, PRODUCTS.price " +
                    "FROM PURCHASES LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
					"GROUP BY PRODUCTS.id ORDER BY SUM(amount) DESC LIMIT 10 " +
							"OFFSET " + o*10;
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
		        st2b = "GROUP BY USERS.sta ORDER BY SUM(amount*price) DESC LIMIT 10 " +
		               "OFFSET ";
			}
			rs = statement.executeQuery(st);
			
			if (action != null && action.equals("table")) {
				session.setAttribute("ty", request.getParameter("ty"));
				if ((request.getParameter("ty")).equals("stas")) {
					st2 = "SELECT USERS.* " +
			              "FROM PURCHASES LEFT JOIN USERS ON USERS.id = PURCHASES.customer " +
		                  "LEFT JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product ";
		            st2b = "GROUP BY USERS.sta ORDER BY SUM(amount*price) DESC LIMIT 10 " +
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
			
			if (action != null && action.equals("filter")) 
			{
				ArrayList<String> l = new ArrayList<String>(); //Dump commands here
				
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
				if(!request.getParameter("sta").equals("ALL"))
					l.add(String.format("USERS.sta = '%s'", request.getParameter("sta")));
				
				
				/*   CAVEAT: THIS IS TOTALLY BROKEN.  We might need to do a triple join here to get the proper numbers?
				
				//doing categories
			   if(!request.getParameter("category").equals("allcats"))
				    l.add(String.format("CATEGORY.nam = '%s'", request.getParameter("category")));
				
				//ResultSet rs6 = conn.createStatement().executeQuery("SELECT * FROM CATEGORY");
				//while (rs6.next())
					*/
					
				//Doing Quarter
				if(!request.getParameter("quarter").equals("entire"))
					l.add(String.format("PURCHASES.season = '%s'", request.getParameter("quarter")));	
				
				//Assemble bits
				if(!l.isEmpty())
				{
					filter += " WHERE " + l.get(0) + " ";
					for(int i = 1; i < l.size(); i++)
						filter += " AND " + l.get(i);
				}
			}
			
		
		
			if (session.getAttribute("username") != null) {
			%>

	<form action="analytics.jsp" method="POST">
		<input type="hidden" name="action" value="table" /> Type: <select
			name="ty">
			<option value="cust">Customers</option>
			<option value="stas">States</option>
		</select>
		<td><input type="submit" value="Table" /></td>
	</form>
	<form action="analytics.jsp" method="POST">
		<input type="hidden" name="action" value="filter" /> Ages: <select
			name="age">
			<option value="allages">All Ages</option>
			<option value="zero">0 - 9</option>
			<option value="ten">10 - 19</option>
			<option value="twenty">20 - 29</option>
			<option value="thirty">30 - 39</option>
			<option value="forty">40 - 49</option>
			<option value="fifty">50 - 59</option>
			<option value="sixty">60 - 69</option>
			<option value="seventy">70 - 79</option>
			<option value="eighty">80 - 89</option>
			<option value="ninety">90 - 99</option>
		</select> States: <select name="sta">
			<option value="ALL">All States</option>
			<option value="AL">Alabama</option>
			<option value="AK">Alaska</option>
			<option value="AZ">Arizona</option>
			<option value="AR">Arkansas</option>
			<option value="CA">California</option>
			<option value="CO">Colorado</option>
			<option value="CT">Connecticut</option>
			<option value="DE">Delaware</option>
			<option value="DC">District Of Columbia</option>
			<option value="FL">Florida</option>
			<option value="GA">Georgia</option>
			<option value="HI">Hawaii</option>
			<option value="ID">Idaho</option>
			<option value="IL">Illinois</option>
			<option value="IN">Indiana</option>
			<option value="IA">Iowa</option>
			<option value="KS">Kansas</option>
			<option value="KY">Kentucky</option>
			<option value="LA">Louisiana</option>
			<option value="ME">Maine</option>
			<option value="MD">Maryland</option>
			<option value="MA">Massachusetts</option>
			<option value="MI">Michigan</option>
			<option value="MN">Minnesota</option>
			<option value="MS">Mississippi</option>
			<option value="MO">Missouri</option>
			<option value="MT">Montana</option>
			<option value="NE">Nebraska</option>
			<option value="NV">Nevada</option>
			<option value="NH">New Hampshire</option>
			<option value="NJ">New Jersey</option>
			<option value="NM">New Mexico</option>
			<option value="NY">New York</option>
			<option value="NC">North Carolina</option>
			<option value="ND">North Dakota</option>
			<option value="OH">Ohio</option>
			<option value="OK">Oklahoma</option>
			<option value="OR">Oregon</option>
			<option value="PA">Pennsylvania</option>
			<option value="RI">Rhode Island</option>
			<option value="SC">South Carolina</option>
			<option value="SD">South Dakota</option>
			<option value="TN">Tennessee</option>
			<option value="TX">Texas</option>
			<option value="UT">Utah</option>
			<option value="VT">Vermont</option>
			<option value="VA">Virginia</option>
			<option value="WA">Washington</option>
			<option value="WV">West Virginia</option>
			<option value="WI">Wisconsin</option>
			<option value="WY">Wyoming</option>
		</select> Categories: <select name="category">
			<option value="allcats">All Categories</option>
			<% rs5 = statement5.executeQuery("SELECT * FROM CATEGORY");
	                       while (rs5.next()) {
	                       		out.println ("<option value=\"" + rs5.getString("nam") + "\">" + rs5.getString("nam") + "</option>");
	                       } %>
		</select> Quarters: <select name="quarter">
			<option value="entire">Full Year</option>
			<option value="Spring">Spring</option>
			<option value="Summer">Summer</option>
			<option value="Fall">Fall</option>
			<option value="Winter">Winter</option>
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
			                	rs = statement.executeQuery(st); %>
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
			                	rs = statement.executeQuery(st); %>
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
		       if (session.getAttribute("row") != null && !(session.getAttribute("row").equals("0"))) out.println ("<a href=" + link + ">Prev</a><br>");
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
		       rs4 = statement4.executeQuery("SELECT COUNT(*) FROM USERS");
		       rs4.next();
		       if ((p+1)*10 < rs4.getInt(1)) out.println ("<a href=" + link + ">Next</a><br>");
		    %>



			</div>
			<div class="row">
				<div class="span1 offset3">
					<% if (session.getAttribute("col") == null || session.getAttribute("col").equals("0")) c = 0;
			   else c = Integer.parseInt(session.getAttribute("col").toString()) - 1;
			   link = "analytics.jsp?col=" + c;
		       if (session.getAttribute("row") != null) link += "&row=" + session.getAttribute("row");
		       if (session.getAttribute("col") != null && !(session.getAttribute("col").equals("0"))) out.println ("<a href=" + link + ">Prev</a><br>");
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
		       rs4 = statement4.executeQuery("SELECT COUNT(*) FROM PRODUCTS");
		       rs4.next();
		       if ((q+1)*10 < rs4.getInt(1)) out.println ("<a href=" + link + ">Next</a><br>");
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