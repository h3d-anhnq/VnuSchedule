package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
	public Connection conn;

	public Database(){
		connectSQL();
	}

	public void connectSQL() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			String url = "jdbc:mysql://127.0.0.1:3306/itplus_end";
			try {
				conn = DriverManager.getConnection(url, "root", "");
//				System.out.println("Success");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		new Database();
	}
}
