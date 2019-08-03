--
-- ���Ʋ��Գ���
-- 
-- ��;�����Ʋ��Գ���
-- 
-- ����					����				��ע
-- Huafeng Lin			2011/01/17			����
-- Huafeng Lin			2011/01/17			�޸�
-- 

LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;
                   
ENTITY shandeng IS                                        
     PORT
     (
          clk:in STD_LOGIC;                                   
          led:out STD_LOGIC
     );     
END shandeng;
                                              
ARCHITECTURE light OF shandeng IS                                     
BEGIN                                                                  
P1:PROCESS (clk)                                              
VARIABLE count:INTEGER RANGE 0 TO 19999999;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN
		IF count<=9999999 THEN                           
			led<='0';
			count:=count+1;                          
		ELSIF count>=9999999 AND count<=19999999 THEN
			led<='1';
			count:=count+1;
		ELSE
			count:=0;
		END IF;                                                      
     END IF;                                          
END PROCESS;   
                             
END light;