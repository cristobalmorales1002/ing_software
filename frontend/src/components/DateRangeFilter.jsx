import React, { forwardRef } from 'react';
import DatePicker, { registerLocale } from 'react-datepicker';
import { Calendar3, XCircleFill } from 'react-bootstrap-icons';
import { es } from 'date-fns/locale/es';
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
        const format = (date) => date ? date.toISOString().split('T')[0] : '';

        onChange({
            inicio: format(start),
            fin: format(end)
        });
    };

    const parseDate = (dateStr) => dateStr ? new Date(dateStr + 'T00:00:00') : null;

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