<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashSet"%>
<%@ page import ="java.util.Iterator" %>
<%@ page import ="java.util.Arrays" %>
<%!

/**
 * Simple class to keep track fo States, categories, and their respective prices.
 *
 * @author Alec
 */
public static class Sta 
{
	/**
	 * The title of the State. e.g. "AL", "CA", "WA"
	 */
	private String title;

	/**
	 * Keeps track of the categories and cummulative prices
	 */
	private HashMap<String, Integer> m = new HashMap<String, Integer>();

	/**
	 * Constructor, takes a String title.
	 * 
	 * @param title The title to assign to this Sta object.
	 */
	public Sta(String title)
	{
		this.title = title;
	}

	/**
	 * Adds a category with the specified price (ie. expenditures). If the category has
	 * already been added once before, add the existing value to price and save it.
	 * 
	 * @param cat The name of the category.
	 * @param price The price/expenditures to add/assign to this category.
	 */
	public void add(String cat, int price)
	{
		Integer i;
		if ((i = m.get(cat)) != null)
			m.put(cat, price + i.intValue());
		else
			m.put(cat, new Integer(price));
	}

	/**
	 * Fetches the price/expenditures for this category in this state.
	 * 
	 * @param cat The category to check
	 * @return The price, or 0 if we don't have any records of this category.
	 */
	public int fetchPrice(String cat)
	{
		Integer temp = m.get(cat);
		return temp == null ? 0 : temp.intValue();
	}
}
%>
<%!
/**
 * A big organizer for Sta objects. Aggregtes Sta objects and gives us some nice sorted
 * data for use in tables.
 * 
 * @author Alec
 * 
 */
public static class StaOrganizer
{

		/**
		 * HashMap which tracks Sta objects.
		 */
		private HashMap<String, Sta> l = new HashMap<String, Sta>();

		/**
		 * Tracks states. HashSet -> no duplicates
		 */
		private HashSet<String> states = new HashSet<String>();

		/**
		 * Tracks categories. HashSet -> no duplicates.
		 */
		private HashSet<String> cats = new HashSet<String>();

		/**
		 * Adds the specified category and price to the specified state. If the state is
		 * non-existent, create a new one. This is basically a fat wrapper for Sta's
		 * <tt>add()</tt>. Just like in Sta's add(), if the category exists already, then grab
		 * the existing price value and add it to our price value
		 * 
		 * @param state The state to add to, specified as a string.
		 * @param cat The category to add to.
		 * @param price The price to add to.
		 */
		public void add(String state, String cat, int price)
		{
			cats.add(cat);

			if (exists(state))
				l.get(state).add(cat, price);
			else
			{
				Sta t = new Sta(state);
				t.add(cat, price);
				l.put(state, t);
				states.add(state);
			}
		}

		/**
		 * Fetches the price/expenditures of a category of a state. 
		 * 
		 * @param state The state to grab the category price from.
		 * @param cat The category to check.
		 * @return The total price/expenditures, or 0 if we don't have this state on record.
		 */
		public int fetchPrice(String state, String cat)
		{
			return exists(state) ? l.get(state).fetchPrice(cat) : 0;
		}

		/**
		 * Checks to see if the given state exists in our list of states.
		 * 
		 * @param state The state to check.
		 * @return True if the Sta exists in this StaOrganizer's list of Sta's.
		 * 
		 * @see #l
		 */
		private boolean exists(String state)
		{
			return l.get(state) == null ? false : true;
		}

		/**
		 * Gets our list of cats, sorted alphabetically.
		 * 
		 * @return The list of cats, sorted A-Z, as Strings.
		 * @see #convert(HashSet)
		 */
		public String[] getCatList()
		{
			return convert(cats);
		}

		/**
		 * Gets our list of states, sorted alphabetically.
		 * @return The list of states, sorted A-Z, as Strings.
		 * @see #convert(HashSet)
		 */
		public String[] getStateList()
		{
			return convert(states);
		}
		
		/**
		 * Takes a HashSet<String>, and converts it to a sorted array.
		 * 
		 * @param x HashSet to convert.
		 * @return The converted hashset, in an array of strings.
		 */
		private String[] convert(HashSet<String> x)
		{
			ArrayList<String> wl = new ArrayList<String>();
			Iterator<String> cl = x.iterator();
			while (cl.hasNext())
				wl.add(cl.next());

			String[] temp = wl.toArray(new String[0]);
			Arrays.sort(temp);
			return temp;
		}
}

%>
<%! private static int counter = 0; %>
<!--  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Live Table View</title>

</head>
<body>
-->
<%
	Class.forName("com.mysql.jdbc.Driver");

try 
{
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
    conn.setAutoCommit(false);
    
    ResultSet rs = conn.createStatement().executeQuery("SELECT USERS.sta, CATEGORY.nam, PRODUCTS.price, PURCHASES.amount " + 
   		 "FROM PURCHASES " +
   		 "INNER JOIN PRODUCTS ON PRODUCTS.id = PURCHASES.product " +
   		 "INNER JOIN CATEGORY ON PRODUCTS.cat = CATEGORY.id " + 
   		 "INNER JOIN USERS ON USERS.id = PURCHASES.customer " + 
   		 "WHERE PURCHASES.today = 1 " + 
   		 "ORDER BY USERS.sta, CATEGORY.nam;");

    
    StaOrganizer o = new StaOrganizer();
    while(rs.next())
   	  o.add(rs.getString(1), rs.getString(2), rs.getInt(3)*rs.getInt(4));
    
   
    String[] cats = o.getCatList();
    String[] states = o.getStateList();
    
    String dump = "<table border=\"1\">\n<tr><th> </th>\n";
    for(String s : cats)
   	  dump += "<th>" + s + "</th>\n";
   	dump += "</tr>\n";
   	
   	for(String state : states)
   	{
   		dump += "<tr>\n<td>" + state + "</td>\n";
   		for(String cat : cats)
   		   dump += "<td>" + o.fetchPrice(state, cat) + "</td>\n";
   	
   		dump += "</tr>\n";
   	}
   	dump +="</table>";
   	out.println(dump);
   	
}
catch(Throwable e)
{
	e.printStackTrace();
}
%>

<p>This page has been refreshed <%= counter++ %> times.</p>
<!--  
</body>
</html>-->