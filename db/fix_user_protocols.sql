ALTER TABLE user_protocols ADD COLUMN IF NOT EXISTS detergent_concentration FLOAT DEFAULT 0;

-- Quitar el índice UNIQUE anterior (si existe) y agregar el nuevo por usuario
DO $$
BEGIN
    -- Intentar borrar el constraint UNIQUE global si existe.
    -- El nombre por defecto en Postgres suele ser user_protocols_protocol_code_key
    ALTER TABLE user_protocols DROP CONSTRAINT IF EXISTS user_protocols_protocol_code_key;

    -- Agregar el nuevo constraint UNIQUE compuesto (user_id + protocol_code)
    -- Esto permite que diferentes usuarios tengan su propio "FER-001"
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_protocols_user_id_protocol_code_key') THEN
        ALTER TABLE user_protocols ADD CONSTRAINT user_protocols_user_id_protocol_code_key UNIQUE (user_id, protocol_code);
    END IF;
END $$;
