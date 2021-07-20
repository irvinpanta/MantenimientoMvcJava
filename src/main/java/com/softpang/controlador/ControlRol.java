package com.softpang.controlador;

import com.mysql.cj.jdbc.CallableStatement;
import com.softpang.modelo.Config;
import com.softpang.modelo.ModeloRol;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class ControlRol {

    private final Config conexion = new Config();
    private Connection cnn; //= conexion.conectado();

    private String sqlCadena = "";

    public DefaultTableModel consultar(int xFlag, String xCriterio) {

        DefaultTableModel modelo;
        
        String[] titulos = {"Rol", "Descripcion", "Activo", "Estado"};
        String[] registros = new String[4];

        modelo = new DefaultTableModel(null, titulos);
        
        try {
            cnn = conexion.conectado();
            sqlCadena = "{Call pa_menRolConsultar(?,?)}";
            CallableStatement cst = (CallableStatement) cnn.prepareCall(sqlCadena);

            cst.setInt(1, xFlag);
            cst.setString(2, xCriterio);

            ResultSet rs = cst.executeQuery();

            while (rs.next()) {

                registros[0] = rs.getString("rol");
                registros[1] = rs.getString("nombre");
                registros[2] = rs.getString("activo");
                registros[3] = rs.getString("Estado");
                

                modelo.addRow(registros);
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e);
        } finally {
            try {
                conexion.desconectado();

            } catch (Exception e) {
            }

        }

        return modelo;
    }

    /*Mantenimiento de Data: Save, Update, Delete*/
    public boolean mantenimientoData(ModeloRol dts) {
        try {
            cnn = conexion.conectado();
            sqlCadena = "{Call pa_menRolMantenimiento(?,?,?,?)}";
            
            CallableStatement cst = (CallableStatement) cnn.prepareCall(sqlCadena);
            cst.setInt(1, dts.getxFlag());
            cst.setString(2, dts.getxRol());
            cst.setString(3, dts.getxDescripcion());
            cst.setInt(4, dts.getActivo());

            int n = cst.executeUpdate();
            
            if (n != 0) {
                return true;
            } else {
                return false;
            }
            
        } catch (SQLException e) {JOptionPane.showMessageDialog(null, e);
            return false;
        } finally {
            conexion.desconectado();
        }
    }
    
}
