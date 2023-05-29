import toast from "react-hot-toast";

const style = {
  borderRadius: "10px",
  background: "#333",
  color: "#fff",
};

export const SuccessToast = (message: string) => toast(message, { icon: "🚀", style });
export const WarningToast = (message: string) => toast(message, { icon: "⚠️", style });
export const ErrorToast = (message: string) => toast(message, { icon: "❌", style });
export const InfoToast = (message: string) => toast(message, { icon: "ℹ️", style });
export const LoadingToast = (message: string) => toast(message, { icon: "⏳", style });
