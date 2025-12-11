-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create ventas table
CREATE TABLE IF NOT EXISTS ventas (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT NOT NULL,
  fecha TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create gastos table
CREATE TABLE IF NOT EXISTS gastos (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT NOT NULL,
  categoria VARCHAR(50) NOT NULL,
  fecha TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create productos table
CREATE TABLE IF NOT EXISTS productos (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  precio DECIMAL(10, 2) NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  descripcion TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_ventas_user_id ON ventas(user_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);
CREATE INDEX idx_gastos_user_id ON gastos(user_id);
CREATE INDEX idx_gastos_fecha ON gastos(fecha);
CREATE INDEX idx_gastos_categoria ON gastos(categoria);
CREATE INDEX idx_productos_user_id ON productos(user_id);

-- Enable RLS (Row Level Security)
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for ventas
CREATE POLICY "Users can view their own ventas" ON ventas
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own ventas" ON ventas
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ventas" ON ventas
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ventas" ON ventas
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for gastos
CREATE POLICY "Users can view their own gastos" ON gastos
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own gastos" ON gastos
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own gastos" ON gastos
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own gastos" ON gastos
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for productos
CREATE POLICY "Users can view their own productos" ON productos
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own productos" ON productos
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own productos" ON productos
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own productos" ON productos
  FOR DELETE USING (auth.uid() = user_id);
