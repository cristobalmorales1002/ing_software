import React, { forwardRef } from 'react';
import DatePicker, { registerLocale } from 'react-datepicker';
import { Calendar3, XCircleFill } from 'react-bootstrap-icons';
import { es } from 'date-fns/locale/es';
// 1. IMPORTAR FORMAT DE DATE-FNS
import { format } from 'date-fns';

import "react-datepicker/dist/react-datepicker.css";
import "./DateRangeFilter.css";

registerLocale('es', es);

const CustomInput = forwardRef(({ value, onClick, onClear }, ref) => (
    <div className="position-relative d-inline-block">
        <div
            className="custom-date-input shadow-sm d-flex align-items-center"
            onClick={onClick}
            ref={ref}
        >
            <Calendar3 size={16} className="me-2 opacity-50 flex-shrink-0"/>

            <span className="text-truncate w-100">
                {value || "Filtrar por fecha..."}
            </span>
        </div>

        {value && (
            <XCircleFill
                className="position-absolute top-50 translate-middle-y text-secondary"
                style={{
                    cursor: 'pointer',
                    right: '10px',
                    zIndex: 10
                }}
                onClick={(e) => {
                    e.stopPropagation();
                    onClear();
                }}
                title="Limpiar fechas"
            />
        )}
    </div>
));

const DateRangeFilter = ({ startDate, endDate, onChange }) => {
    const handleChange = (dates) => {
        const [start, end] = dates;

        // 2. CAMBIO AQUÍ: Usar format() en lugar de toISOString() para evitar cambios de zona horaria
        const formatStr = (date) => date ? format(date, 'yyyy-MM-dd') : '';

        onChange({
            inicio: formatStr(start),
            fin: formatStr(end)
        });
    };

    // Parseo seguro para evitar errores de zona horaria al visualizar lo seleccionado
    const parseDate = (dateStr) => {
        if (!dateStr) return null;
        // Crear fecha tratando la cadena como local (reemplazando guiones por slashes ayuda en algunos navegadores,
        // pero agregar T00:00:00 es lo estándar para ISO local)
        return new Date(dateStr + 'T00:00:00');
    };

    return (
        <DatePicker
            selected={parseDate(startDate)}
            onChange={handleChange}
            startDate={parseDate(startDate)}
            endDate={parseDate(endDate)}
            selectsRange
            locale="es"
            dateFormat="dd MMM yyyy"
            isClearable={false}
            customInput={
                <CustomInput
                    onClear={() => onChange({ inicio: '', fin: '' })}
                />
            }
            placeholderText="Seleccionar rango"
            shouldCloseOnSelect={false}
            monthsShown={1}
            popperPlacement="bottom-end"
        />
    );
};

export default DateRangeFilter;