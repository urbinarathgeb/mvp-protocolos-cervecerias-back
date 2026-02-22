CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    user_id VARCHAR(128) NOT NULL, -- firebase_uid
    user_email VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'open', -- 'open', 'in_progress', 'resolved', 'closed'
    admin_response TEXT,
    responded_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

