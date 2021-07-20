
package com.softpang.modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.swing.JOptionPane;


public class Config {
    
    public Config(){}
    
    private final String database = "dbprueba";
    private final String url = "jdbc:mysql://127.0.0.1/" + database;
    private final String usuario = "root";
    private final String pas = "";
    
    private Connection cnn = null;
    
    public Connection conectado(){
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); //com.mysql.cj.jdbc.Driver
            cnn = DriverManager.getConnection(url, usuario, pas);
            
        } catch (ClassNotFoundException | SQLException e) {
            JOptionPane.showMessageDialog(null, e);
        }
        
        return cnn;
    }
    
    public void desconectado(){
        try {
            if (cnn != null){
                cnn.close();
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e);
        }
    }
    
}
