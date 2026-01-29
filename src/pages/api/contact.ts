import type { APIRoute } from "astro";
import { Resend } from "resend";

const resend = new Resend(import.meta.env.RESEND_API_KEY);

export const POST: APIRoute = async ({ request }) => {
  try {
    const formData = await request.formData();
    const name = formData.get("name")?.toString();
    const email = formData.get("email")?.toString();
    const phone = formData.get("phone")?.toString();
    const subject = formData.get("subject")?.toString();
    const message = formData.get("message")?.toString();

    if (!name || !email || !message) {
      return new Response(
        JSON.stringify({ error: "Veuillez remplir tous les champs requis." }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    const { error } = await resend.emails.send({
      from: "Contact Site Web <bienvenue@ladentdugeant.be>",
      to: "bienvenue@ladentdugeant.be",
      replyTo: email,
      subject: subject || `Nouveau message de ${name}`,
      html: `
        <h2>Nouveau message depuis le formulaire de contact</h2>
        <p><strong>Nom:</strong> ${name}</p>
        <p><strong>Email:</strong> ${email}</p>
        ${phone ? `<p><strong>Téléphone:</strong> ${phone}</p>` : ""}
        ${subject ? `<p><strong>Sujet:</strong> ${subject}</p>` : ""}
        <p><strong>Message:</strong></p>
        <p>${message.replace(/\n/g, "<br>")}</p>
      `,
    });

    if (error) {
      console.error("Resend error:", error);
      return new Response(
        JSON.stringify({ error: "Erreur lors de l'envoi du message." }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ success: true, message: "Message envoyé avec succès!" }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.error("Contact form error:", error);
    return new Response(JSON.stringify({ error: "Une erreur est survenue." }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
};
