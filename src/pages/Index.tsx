import { BirthCertificateForm } from "@/components/BirthCertificateForm";

const Index = () => {
  return (
    <div className="min-h-screen bg-background p-4">
      <div className="container mx-auto py-8">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold mb-4">Birth Certificate Generation</h1>
          <p className="text-xl text-muted-foreground">Complete the form below to generate your birth certificate</p>
        </div>
        <BirthCertificateForm />
      </div>
    </div>
  );
};

export default Index;
