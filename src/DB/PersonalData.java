package DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.catalina.tribes.util.Arrays;

public class PersonalData {
	public int offset = 0;
	public String[] daysOfweek = new String[7];
	public Database db;
	public Connection connection;
	public ResultSet result;
	public List<String[]> list_rs = new ArrayList<String[]>();

	public PersonalData() {
		this.db = new Database();
		connection = db.conn;
		this.offset = 0;
		getDaysOfWeeks(0);
	}

	public PersonalData(int offset) {
		this.db = new Database();
		connection = db.conn;
		this.offset = offset;
		getDaysOfWeeks(offset);
	}

	public void getDaysOfWeeks(int offset) {
		this.offset = offset;
		Calendar now = Calendar.getInstance();
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
		// add 2 if your week start on monday
		int delta = -now.get(GregorianCalendar.DAY_OF_WEEK) + 2 + this.offset * 7;
		now.add(Calendar.DAY_OF_MONTH, delta);
		for (int i = 0; i < 7; i++) {
			daysOfweek[i] = format.format(now.getTime());
			now.add(Calendar.DAY_OF_MONTH, 1);
		}
	}

	public String[] get_data_in_list(String index) {
		for (int i = 0; i < list_rs.size(); i++) {
			if (list_rs.get(i)[0].compareTo(index) == 0) {
				return list_rs.get(i);
			}
		}
		return null;
	}

	public int get_user_by_ma_sv(String masv) {
		Connection connection = db.conn;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			String query = "SELECT * FROM `users` WHERE ma_sv = ?";
			ps = connection.prepareStatement(query);
			ps.setString(1, masv);
			rs = ps.executeQuery();
			while (rs.next()) {
				int user_id = rs.getInt("id");
				return user_id;
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		return -1;
	}

	public void add_user(String ma_sv, String name) {
		PreparedStatement ps = null;
		try {
			String query = "INSERT INTO `users`(`ma_sv`, `name`) values (?,?)";
			ps = connection.prepareStatement(query);
			ps.setString(1, ma_sv);
			ps.setString(2, name);
			ps.executeUpdate();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public java.sql.Date convertStringToDate(String string) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date date;
		try {
			date = sdf.parse(string);
			java.sql.Date sqlStartDate = new java.sql.Date(date.getTime());
			return sqlStartDate;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void add_pesonal_data(int user_id, String name, String date, String place, int start_at, int preriods) {
		PreparedStatement ps = null;
//		System.out.println(name);
		Date created_at = new Date();
		try {
			String query = "INSERT INTO `personal_schedule`(`user_id`, `name`, `day`, `place`,`start_at`, `periods`, `created_at`) values (?,?,?,?,?,?,?)";
			ps = connection.prepareStatement(query);
			ps.setInt(1, user_id);
			ps.setString(2, name);
			ps.setDate(3, convertStringToDate(date));
			ps.setString(4, place);
			ps.setInt(5, start_at);
			ps.setInt(6, preriods);
			ps.setDate(7, new java.sql.Date(created_at.getTime()));
			ps.executeUpdate();
			System.out.println(ps);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		PersonalData db = new PersonalData();
		db.add_pesonal_data(1, "Việc Nhà", "2019-05-15", "Nhà", 1, 3);
	}
	
	public String[] get_data_by_id(int id) {
		Connection connection = db.conn;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			String query = "SELECT *,DAYOFWEEK(day) as week_day FROM `personal_schedule` WHERE id=?";
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] data = new String[7];
				data[0] = rs.getString("id");
				data[1] = rs.getString("name");
				data[2] = rs.getDate("day").toString();
				data[3] = rs.getString("place");
				data[4] = Integer.toString(rs.getInt("start_at"));
				data[5] = Integer.toString(rs.getInt("periods"));
				data[6] = Integer.toString(rs.getInt("week_day"));
				return data;
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		return null;
	}

	public void get_data_by_week(int user_id, int offset) {
		Connection connection = db.conn;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			String query = "SELECT *,DAYOFWEEK(day) as week_day FROM `personal_schedule` WHERE user_id = ? AND day >= ? AND day <= ? ORDER BY DAYOFWEEK(day) ASC";
			ps = connection.prepareStatement(query);
			ps.setInt(1, user_id);
			ps.setString(2, convertDateToString(daysOfweek[0]));
			ps.setString(3, convertDateToString(daysOfweek[6]));
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] data = new String[7];
				data[0] = rs.getString("id");
				data[1] = rs.getString("name");
				data[2] = rs.getDate("day").toString();
				data[3] = rs.getString("place");
				data[4] = Integer.toString(rs.getInt("start_at"));
				data[5] = Integer.toString(rs.getInt("periods"));
				data[6] = Integer.toString(rs.getInt("week_day"));
				this.list_rs.add(data);
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public String convertDateToString(String date) {
		String[] split = date.split("/");
		return split[2] + split[0] + split[1];
	}

	public String getDayByIndex(int i) {
		String[] split = this.daysOfweek[i].split("/");
		return split[1] + "/" + split[0];
	}

	public void update_pesonal(int id, String name, String date, String place, int start_at, int periods) {
		PreparedStatement ps = null;
		Date created_at = new Date();
		try {
			String query = "UPDATE `personal_schedule` SET `name`=?,`day`=?,`place`=?,`updated_at`=?,`start_at`=?,`periods`=? WHERE id = ?";
			ps = connection.prepareStatement(query);
			ps.setString(1, name);
			ps.setDate(2, convertStringToDate(date));
			ps.setString(3, place);
			ps.setDate(4, new java.sql.Date(created_at.getTime()));
			ps.setInt(5, start_at);
			ps.setInt(6, periods);
			ps.setInt(7, id);
			ps.executeUpdate();
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public void delete_data(int id) {
		PreparedStatement ps = null;
		try {
			String query = "delete from `personal_schedule` where id=?";
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}
