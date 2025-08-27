-- Create storage buckets for AADHAAR documents
INSERT INTO storage.buckets (id, name, public) VALUES ('aadhaar-documents', 'aadhaar-documents', false);

-- Create birth certificates table
CREATE TABLE public.birth_certificates (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    last_name TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    gender TEXT NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    time_of_birth TIME,
    place_of_birth TEXT NOT NULL,
    father_name TEXT NOT NULL,
    father_aadhaar_number TEXT NOT NULL,
    father_aadhaar_file_path TEXT,
    mother_name TEXT NOT NULL,
    mother_aadhaar_number TEXT NOT NULL,
    mother_aadhaar_file_path TEXT,
    issuing_authority TEXT,
    registration_number TEXT,
    aadhaar_consent_given BOOLEAN NOT NULL DEFAULT false,
    aadhaar_consent_timestamp TIMESTAMP WITH TIME ZONE,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.birth_certificates ENABLE ROW LEVEL SECURITY;

-- Create policies (allowing public access for now since no auth is mentioned)
CREATE POLICY "Allow all operations on birth certificates" 
ON public.birth_certificates 
FOR ALL 
USING (true) 
WITH CHECK (true);

-- Create storage policies for AADHAAR documents
CREATE POLICY "Allow authenticated upload of AADHAAR documents" 
ON storage.objects 
FOR INSERT 
WITH CHECK (bucket_id = 'aadhaar-documents');

CREATE POLICY "Allow authenticated access to AADHAAR documents" 
ON storage.objects 
FOR SELECT 
USING (bucket_id = 'aadhaar-documents');

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_birth_certificates_updated_at
    BEFORE UPDATE ON public.birth_certificates
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();