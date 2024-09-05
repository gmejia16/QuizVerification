class agent #(parameter with = 16, parameter depth = 8);
    trans_fifo_mbx agnt_drv_mbx;
    comando_test_agent_mbx test_agent_mbx;
    int num_transacciones;
    int max_retardo;
    int ret_spec;
    tipo_trans tpo_spec;
    bit [width-1:0] dto_spec;
    instrucciones_agente instruccion;
    trans_fifo #(.width(width)) transaccion;

    function new;
        num_transacciones = 2;
        max_retardo = 10;
    endfunction

    task run;
        $display("[%g] El agente fue inicializado", $time);
        forever begin
            #1
            if (test_agent_mbx.get() > 0) begin
                $display("[%g] Agente: se recibe instruccion", $time);
                test_agent_mbx.get(instruccion);
                case (instruccion)
                    llenado_aleatorio: begin //esta instruccion genera num_transacciones seguidas del mismo numero de lecturas
                        for (int = 0; i < num_transacciones ; i++ ) begin
                            transaccion = new;
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize();
                            tpo_spec = escritura;
                            transaccion.tipo = tpo_spec;
                            transaccion.print("Agente: transacción creada");
                            agnt_drv_mbx.put(transaccion);
                        end

                        for (int i = 0 ; i < num_transacciones ; i++ ) begin
                            transaccion = new;
                            transaccion.randomize();
                            tpo_spec = lectura;
                            transaccion.tipo = tpo_spec;
                            transaccion.print("Agente: transacción creada");
                            agnt_drv_mbx.put(transaccion);                            
                        end

                        for (int i = 0 ; i < num_transacciones ; i++ ) begin
                            transaccion = new;
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize();
                            tpo_spec = lectura_escritura;
                            transaccion.tipo = tpo_spec;
                            transaccion.print("Agente: transacción creada");
                            agnt_drv_mbx.put(transaccion);                            
                        end
                    end 

                    trans_aleatoria: begin //esta instrucción genera una transaccion aleatoria
                        transaccion = new;
                        transaccion.max_retardo = max_retardo;
                        transaccion.randomize/;
                        transaccion.print("Agente: transacción creada");
                        agnt_drv_mbx.put(transaccion);
                    end 
                    
                    trans_especifica; begin
                        transaccion = new;
                        transaccion.tipo = tpo_spec;
                        transaccion.dato = dto_spec;
                        transaccion.retardo = ret_spec;
                        transaccion.print("Agente: Transacción creada");
                        agnt_drv_mbx.put(transaccion);
                    end

                    sec_trans_aleatorias: begin //Esta instrucción genera una secuencia de instrucciones aleatorias 
                        for (int i = 0 ; i  num_transacciones ; i++ ) begin
                            transaccion = new;
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize();
                            transaccion.print("Agente: transacción creada");
                            agnt_drv_mbx.put(transaccion);
                        end
                    end
                endcase
                
            end
        end


    endtask

endclass