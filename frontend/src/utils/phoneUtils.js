export const COUNTRY_PHONE_DATA = [
    { code: '+56', label: 'CL (+56)', placeholder: '912345678', maxLength: 9 },
    { code: '+54', label: 'AR (+54)', placeholder: '9 11 1234 5678', maxLength: 11 },
    { code: '+51', label: 'PE (+51)', placeholder: '912 345 678', maxLength: 9 },
    { code: '+591', label: 'BO (+591)', placeholder: '7123 4567', maxLength: 8 },
    { code: '+55', label: 'BR (+55)', placeholder: '11 91234 5678', maxLength: 11 },
    { code: '+57', label: 'CO (+57)', placeholder: '300 123 4567', maxLength: 10 },
    { code: '+1', label: 'US (+1)', placeholder: '555 123 4567', maxLength: 10 },
    { code: '+34', label: 'ES (+34)', placeholder: '612 345 678', maxLength: 9 },
];
export const getPhoneConfig = (countryCode) => {
    return COUNTRY_PHONE_DATA.find(c => c.code === countryCode) || { maxLength: 15, placeholder: '' };
};