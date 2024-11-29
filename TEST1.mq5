//+------------------------------------------------------------------+  
//|                                                        CandleType.mq5 |  
//|                        Copyright 2024, YourName                    |  
//|                                       https://www.yourwebsite.com |  
//+------------------------------------------------------------------+  
#property strict  

// Input parameters  
input int atrPeriod = 264; // ATR calculation period  

// Function to classify a candle  
string ClassifyCandle(double highLowRange, double atrValue) {  
    if (highLowRange < atrValue * 0.79) {  
        return "Sniping Candle";  
    } else if (highLowRange >= atrValue * 0.8 && highLowRange <= atrValue * 1.2) {  
        return "Standard Candle";  
    } else if (highLowRange > atrValue * 1.2 && highLowRange <= atrValue * 1.79) {  
        return "Long Bar Candle";  
    } else if (highLowRange > atrValue * 1.79) {  
        return "Spike Candle";  
    }  
    return "Unknown Candle Type"; // Fallback case  
}

// Main function  
void OnStart() {  
    // Create ATR indicator handle
    int atrHandle = iATR(NULL, PERIOD_H1, atrPeriod);
    if (atrHandle == INVALID_HANDLE) {
        Print("Error creating ATR handle");
        return;
    }

    // Array to store ATR values
    double atrValues[];
    ArraySetAsSeries(atrValues, true);

    // Copy ATR values for the last 10 candles
    int copied = CopyBuffer(atrHandle, 0, 0, 10, atrValues);
    if (copied <= 0) {
        Print("Error copying ATR values");
        return;
    }

    // Loop through the last 10 candles  
    for (int i = 0; i < 10; i++) {  
        double high = iHigh(NULL, PERIOD_H1, i);  
        double low = iLow(NULL, PERIOD_H1, i);  
        double highLowRange = high - low; // Calculate high-low range  

        // Get ATR value for the current candle from the array
        double atrValue = atrValues[i];  

        // Classify the candle  
        string candleType = ClassifyCandle(highLowRange, atrValue);  
        
        // Print the candle type  
        Print("Candle ", i + 1, ": Type = ", candleType,  
              ", High = ", high, ", Low = ", low,  
              ", H-L Range = ", highLowRange,  
              ", ATR = ", atrValue);  
    }  
}  
//+------------------------------------------------------------------+
