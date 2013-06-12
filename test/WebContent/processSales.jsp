<%@page import="java.util.*, org.json.simple.JSONObject" %>
<%@ page import="java.io.*,javax.servlet.*,java.text.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.sql.*"%>
    <% try {
    	Connection conn = null;
		Statement statement = null;
		ResultSet rs = null;
	    Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
		statement = conn.createStatement();
		rs = statement.executeQuery("select * from cse135.CATEGORY ORDER BY CATEGORY.nam");
		
		Calendar calendar = Calendar.getInstance();
	    calendar.getTime();
	    if (application.getAttribute("day") == null)
	   	   application.setAttribute("day", calendar.get(Calendar.DAY_OF_MONTH));
	    int today = calendar.get(Calendar.DAY_OF_MONTH);
	    boolean newDay = ((Integer) application.getAttribute("day")) != today;
       
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
       if(application.getAttribute("newThings")==null || newDay) 
            application.setAttribute("newThings", new LinkedHashMap<String, LinkedHashMap<String, Integer> >());
       
        LinkedHashMap<String, LinkedHashMap<String, Integer> > purchases
        	= (LinkedHashMap<String, LinkedHashMap<String, Integer> >) application.getAttribute("purchases");
   		LinkedHashMap<String, LinkedHashMap<String, Integer> > newThings
			= (LinkedHashMap<String, LinkedHashMap<String, Integer> >) application.getAttribute("newThings");

   		// browse the new purchases and stuff
		Iterator it = newThings.entrySet().iterator();
   		
		
		String result = "[";
		while(it.hasNext()){
			Map.Entry pair = (Map.Entry) it.next();
			String categoryName = (String) pair.getKey();
			Iterator it2 = ((LinkedHashMap<String, Integer>) pair.getValue()).entrySet().iterator();
			while (it2.hasNext()) {
				Map.Entry pair2 = (Map.Entry) it2.next();
				LinkedHashMap<String, Integer> update = purchases.get(categoryName);
				
				Integer originalAmount = update.get(pair2.getKey());
				update.put((String) pair2.getKey(), (Integer) pair2.getValue() + originalAmount);
				
				JSONObject r = new JSONObject();
				r.put("category", categoryName);
				r.put("state", pair2.getKey());
				r.put("amount", update.get(pair2.getKey()));
				result += r.toString();
			}
			if (it.hasNext())
				result += ",";
		}
		result += "]";
		System.out.println(result);
		out.print(result);
	    out.flush();
		newThings.clear();
		rs.close();
		statement.close();
		conn.close();
	    } catch (Exception e) {
		System.out.println (e);
		System.out.println ("also you suck?!!?!?!?!??!");
	}
	%>