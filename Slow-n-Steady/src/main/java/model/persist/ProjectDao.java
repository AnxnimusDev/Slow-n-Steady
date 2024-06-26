/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.persist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.DbConnect;
import model.Project;

/**
 *
 * @author anxnimus
 */
public class ProjectDao {

    private final DbConnect dbConnect;
    private Map<String, String> queries;

    public ProjectDao() {
        dbConnect = new DbConnect();
        queries = new HashMap<>();
        initQueries();
    }

    private void initQueries() {
        //Selects all existing projects
        queries.put("selectProjects", "SELECT * FROM project;");
        //Selects all existing projects 
        queries.put("selectIdProjectsByName", "SELECT p.id FROM project AS p WHERE p.name = ?;");
        //Creates a Project
        queries.put("addProject", "INSERT INTO project VALUES(null, ?, ?, ?, ?)");
        //Deletes a Project by Id
        queries.put("deleteProject", "DELETE FROM project WHERE id = ?;");
        //Updates existing Project by ID, given a new Project Object
        queries.put("updateProject", "UPDATE project SET name = ?, description = ?, starting_date = ? WHERE id = ?");
    }

    /**
     * Method that obtains a Project object with the data obtained from the
     * database.
     *
     * @param rs
     * @return Project object with that data
     * @throws SQLException in case of error
     */
    public Project projectFromResultSet(ResultSet rs) throws SQLException {
        Project project;
        //We read the attributes fetched from the queries
        long id = rs.getLong("id");
        String name = rs.getString("name");
        String description = rs.getString("description");
        Date creationDate = rs.getDate("creation_date");
        Date startDate = rs.getDate("starting_date");
        //We instantiate a new User object usign the previous attributes
        project = new Project(id, name, description, creationDate, startDate);
        return project;
    }

    /**
     * Lists all existant projects from the database.
     *
     * @return a list with all the projects or null in case any error takes
     * place.
     */
    public List<Project> selectAllProjects() throws SQLException {
        List<Project> result = new ArrayList<>();
        try (Connection conn = dbConnect.getConnection()) {
            String query = queries.get("selectProjects");
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                var project = projectFromResultSet(rs);
                if (project != null) {
                    result.add(project);
                }
            }
        }
        return result;
    }

    public long selectProjectIdByName(String name) throws SQLException {
        long projectId = 0;
        try (Connection conn = dbConnect.getConnection()) {
            String query = queries.get("selectIdProjectsByName");
            PreparedStatement st = conn.prepareStatement(query);
            st.setString(1, name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                projectId = rs.getLong("id");
            }
        }
        return projectId;
    }

    /**
     * Adds a Project into the database table given a Project Object with all
     * its data
     *
     * @param project with the new project data
     * @return 1 if successfull, 0 in case any error takes place.
     * @throws java.sql.SQLException
     */
    public int createProject(Project project) throws SQLException {
        int result = 0;
        try (Connection conn = dbConnect.getConnection()) {
            String query = queries.get("addProject");
            PreparedStatement st = conn.prepareStatement(query);
            st.setString(1, project.getName());
            st.setString(2, project.getDescription());
            st.setDate(3, new java.sql.Date(project.getCreationDate().getTime()));
            st.setDate(4, new java.sql.Date(project.getStartDate().getTime()));
            result = st.executeUpdate();
        }
        return result;
    }

    /**
     * Deletes a Project from database given the projectId.
     *
     * @param projectId of the project we want to delete
     * @return 1 if successfull, 0 in case of any error takes place.
     * @throws java.sql.SQLException
     */
    public int deleteProject(long projectId) throws SQLException {
        int result = 0;
        try (Connection conn = dbConnect.getConnection()) {
            String query = queries.get("deleteProject");
            PreparedStatement st = conn.prepareStatement(query);
            st.setLong(1, projectId);
            result = st.executeUpdate();
        }
        return result;
    }

    /**
     * Modifies a project given its id and a new Project object with the updated
     * data, except the creation_date, which will never be changed.
     *
     * @param projectId
     * @param updatedProject
     * @return
     * @throws java.sql.SQLException
     */
    public int modifyProject(long projectId, Project updatedProject) throws SQLException {
        int result = 0;
        try (Connection conn = dbConnect.getConnection()) {
            String query = queries.get("updateProject");
            PreparedStatement st = conn.prepareStatement(query);
            st.setString(1, updatedProject.getName());
            st.setString(2, updatedProject.getDescription());
            st.setDate(3, new java.sql.Date(updatedProject.getStartDate().getTime()));
            st.setLong(4, projectId);

            result = st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
