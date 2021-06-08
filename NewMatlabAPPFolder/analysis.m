classdef analysis < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MIAnalysisUIFigure            matlab.ui.Figure
        PrintButton                   matlab.ui.control.Button
        StudyFieldPanel               matlab.ui.container.Panel
        ShowDropDown                  matlab.ui.control.DropDown
        ShowLabel                     matlab.ui.control.Label
        ROIRegionsofInterestPanel     matlab.ui.container.Panel
        ShowROICheckBox               matlab.ui.control.CheckBox
        ReportPanel                   matlab.ui.container.Panel
        ReportformatDropDown          matlab.ui.control.DropDown
        ReportformatDropDownLabel     matlab.ui.control.Label
        GeneratereportButton          matlab.ui.control.Button
        SaveButton                    matlab.ui.control.Button
        SegmentdataPanel              matlab.ui.container.Panel
        AudiotypeTextArea             matlab.ui.control.TextArea
        AudiotypeTextAreaLabel        matlab.ui.control.Label
        FacetypeTextArea              matlab.ui.control.TextArea
        FacetypeTextAreaLabel         matlab.ui.control.Label
        CleanButton                   matlab.ui.control.Button
        FileselectedTextArea          matlab.ui.control.TextArea
        FileselectedTextAreaLabel     matlab.ui.control.Label
        FilterPanel                   matlab.ui.container.Panel
        FilterCheckBox                matlab.ui.control.CheckBox
        BandselectionDropDown_2       matlab.ui.control.DropDown
        BandselectionDropDown_2Label  matlab.ui.control.Label
        SelectallCheckBox             matlab.ui.control.CheckBox
        PO7_Button                    matlab.ui.control.StateButton
        O1_Button                     matlab.ui.control.StateButton
        PO3_Button                    matlab.ui.control.StateButton
        P7_Button                     matlab.ui.control.StateButton
        P5_Button                     matlab.ui.control.StateButton
        P3_Button                     matlab.ui.control.StateButton
        P1_Button                     matlab.ui.control.StateButton
        CP5_Button                    matlab.ui.control.StateButton
        CP3_Button                    matlab.ui.control.StateButton
        PO8_Button                    matlab.ui.control.StateButton
        O2_Button                     matlab.ui.control.StateButton
        PO4_Button                    matlab.ui.control.StateButton
        P8_Button                     matlab.ui.control.StateButton
        P6_Button                     matlab.ui.control.StateButton
        P4_Button                     matlab.ui.control.StateButton
        P2_Button                     matlab.ui.control.StateButton
        TP8_Button                    matlab.ui.control.StateButton
        CP6_Button                    matlab.ui.control.StateButton
        CP4_Button                    matlab.ui.control.StateButton
        FT7_Button                    matlab.ui.control.StateButton
        FC5_Button                    matlab.ui.control.StateButton
        FC3_Button                    matlab.ui.control.StateButton
        TP7_Button                    matlab.ui.control.StateButton
        AF3_Button                    matlab.ui.control.StateButton
        F1_Button                     matlab.ui.control.StateButton
        AF7_Button                    matlab.ui.control.StateButton
        Fp1_Button                    matlab.ui.control.StateButton
        AF8_Button                    matlab.ui.control.StateButton
        F5_Button                     matlab.ui.control.StateButton
        F7_Button                     matlab.ui.control.StateButton
        F3_Button                     matlab.ui.control.StateButton
        Fp2_Button                    matlab.ui.control.StateButton
        F8_Button                     matlab.ui.control.StateButton
        F6_Button                     matlab.ui.control.StateButton
        F4_Button                     matlab.ui.control.StateButton
        F2_Button                     matlab.ui.control.StateButton
        FT8_Button                    matlab.ui.control.StateButton
        FC6_Button                    matlab.ui.control.StateButton
        AF4_Button                    matlab.ui.control.StateButton
        FC4_Button                    matlab.ui.control.StateButton
        CP2_Button                    matlab.ui.control.StateButton
        CP1_Button                    matlab.ui.control.StateButton
        FC2_Button                    matlab.ui.control.StateButton
        FC1_Button                    matlab.ui.control.StateButton
        CPz_Button                    matlab.ui.control.StateButton
        Pz_Button                     matlab.ui.control.StateButton
        Oz_Button                     matlab.ui.control.StateButton
        Fpz_Button                    matlab.ui.control.StateButton
        Fz_Button                     matlab.ui.control.StateButton
        FCz_Button                    matlab.ui.control.StateButton
        C1_Button                     matlab.ui.control.StateButton
        C3_Button                     matlab.ui.control.StateButton
        C5_Button                     matlab.ui.control.StateButton
        T7_Button                     matlab.ui.control.StateButton
        T8_Button                     matlab.ui.control.StateButton
        C6_Button                     matlab.ui.control.StateButton
        C4_Button                     matlab.ui.control.StateButton
        C2_Button                     matlab.ui.control.StateButton
        Cz_Button                     matlab.ui.control.StateButton
        SelectfileButton              matlab.ui.control.Button
        UIAxes2                       matlab.ui.control.UIAxes
        UIAxes                        matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        discretization=0;
        discret;
        fs=250;
        
        %Channels
        Fp1;
        Fpz;
        AF7;
        AF3;
        AF4;
        AF8;
        F7;
        F5;
        F3;
        F1;
        Fz;
        F2;
        F4;
        F6;
        F8;
        Fp2;
        FT7;
        FC5;
        FC3;
        FC1;
        FCz;
        FC2;
        FC4;
        FC6;
        FT8;
        T7;
        C5;
        C3;
        C1;
        Cz;
        C2;
        C4;
        C6;
        T8;
        TP7;
        CP5;
        CP3;
        CP1;
        CPz;
        CP2;
        CP4;
        CP6;
        TP8;
        P7;
        P5;
        P3;
        P1;
        Pz;
        P2;
        P4;
        P6;
        P8;
        PO7;
        PO3;
        PO4;
        PO8;
        O1;
        Oz;
        O2;
        HEOGplus;
        HEOG;
        VEOGplus;
        VEOG;
        M1;
        
        %filtred channels
        %Channels
        Fp1_filtred;
        Fpz_filtred;
        AF7_filtred;
        AF3_filtred;
        AF4_filtred;
        AF8_filtred;
        F7_filtred;
        F5_filtred;
        F3_filtred;
        F1_filtred;
        Fz_filtred;
        F2_filtred;
        F4_filtred;
        F6_filtred;
        F8_filtred;
        Fp2_filtred;
        FT7_filtred;
        FC5_filtred;
        FC3_filtred;
        FC1_filtred;
        FCz_filtred;
        FC2_filtred;
        FC4_filtred;
        FC6_filtred;
        FT8_filtred;
        T7_filtred;
        C5_filtred;
        C3_filtred;
        C1_filtred;
        Cz_filtred;
        C2_filtred;
        C4_filtred;
        C6_filtred;
        T8_filtred;
        TP7_filtred;
        CP5_filtred;
        CP3_filtred;
        CP1_filtred;
        CPz_filtred;
        CP2_filtred;
        CP4_filtred;
        CP6_filtred;
        TP8_filtred;
        P7_filtred;
        P5_filtred;
        P3_filtred;
        P1_filtred;
        Pz_filtred;
        P2_filtred;
        P4_filtred;
        P6_filtred;
        P8_filtred;
        PO7_filtred;
        PO3_filtred;
        PO4_filtred;
        PO8_filtred;
        O1_filtred;
        Oz_filtred;
        O2_filtred;
        HEOGplus_filtred;
        HEOG_filtred;
        VEOGplus_filtred;
        VEOG_filtred;
        M1_filtred;
        
        Fp1MI;
        FpzMI;
        AF7MI;
        AF3MI;
        AF4MI;
        AF8MI;
        F7MI;
        F5MI;
        F3MI;
        F1MI;
        FzMI;
        F2MI;
        F4MI;
        F6MI;
        F8MI;
        Fp2MI;
        FT7MI;
        FC5MI;
        FC3MI;
        FC1MI;
        FCzMI;
        FC2MI;
        FC4MI;
        FC6MI;
        FT8MI;
        T7MI;
        C5MI;
        C3MI;
        C1MI;
        CzMI;
        C2MI;
        C4MI;
        C6MI;
        T8MI;
        TP7MI;
        CP5MI;
        CP3MI;
        CP1MI;
        CPzMI;
        CP2MI;
        CP4MI;
        CP6MI;
        TP8MI;
        P7MI;
        P5MI;
        P3MI;
        P1MI;
        PzMI;
        P2MI;
        P4MI;
        P6MI;
        P8MI;
        PO7MI;
        PO3MI;
        PO4MI;
        PO8MI;
        O1MI;
        OzMI;
        O2MI;
        
        %Bandpass filter parameter
        wn_delta=[1 3];
        wn_thetal=[3 5]; %theta low
        wn_thetah=[5 7]; %theta high
        wn=[1 3];
        filter=0;
        
        
        legend= categorical(); % x axis for histograms
        signals_ploted=[]; % y axis for histograms
        AudioFile 
        printed=0;
        myFigure
        type % type of figure: histogram or tension
        AudioCode % Description
        FaceCode % Description
        MIvector % Description
        StimStart % Description
        AudioStart % Description
        AudioEnd
        duracion % Description
        FileAlreadySelected=0 % Description
        myFileName % Description
        estimulo
        final
        higherMIs % Description
        segmentName % Description
        subject
    end
    
    methods (Access = private)
        
        function result = filter_signals(app)
            fc_1 = app.wn(2);
            [b1,a1] = butter(3,fc_1/(app.fs/2)); %freqz(b,a)
            
            fc_2 = app.wn(1);
            [b2,a2] = butter(3,fc_2/(app.fs/2),'high'); %freqz(b,a)
            
            function result = filter_channel(channel)
                channel=app.filter(b1,a1,channel);
                result=app.filter(b2,a2,channel);
            end
            
            app.Fp1_filtred=filter_channel(app.Fp1);
            app.Fpz_filtred=filter_channel(app.Fpz);
            app.AF7_filtred=filter_channel(app.AF7);
            app.AF3_filtred=filter_channel(app.AF3);
            app.AF4_filtred=filter_channel(app.AF4);
            app.AF8_filtred=filter_channel(app.AF8);
            app.F7_filtred=filter_channel(app.F7);
            app.F5_filtred=filter_channel(app.F5);
            app.F3_filtred=filter_channel(app.F3);
            app.F1_filtred=filter_channel(app.F1);
            app.Fz_filtred=filter_channel(app.Fz);
            app.F2_filtred=filter_channel(app.F2);
            app.F4_filtred=filter_channel(app.F4);
            app.F6_filtred=filter_channel(app.F6);
            app.F8_filtred=filter_channel(app.F8);
            app.Fp2_filtred=filter_channel(app.Fp2);
            app.FT7_filtred=filter_channel(app.FT7);
            app.FC5_filtred=filter_channel(app.FC5);
            app.FC3_filtred=filter_channel(app.FC3);
            app.FC1_filtred=filter_channel(app.FC1);
            app.FCz_filtred=filter_channel(app.FCz);
            app.FC2_filtred=filter_channel(app.FC2);
            app.FC4_filtred=filter_channel(app.FC4);
            app.FC6_filtred=filter_channel(app.FC6);
            app.FT8_filtred=filter_channel(app.FT8);
            app.T7_filtred=filter_channel(app.T7);
            app.C5_filtred=filter_channel(app.C5);
            app.C3_filtred=filter_channel(app.C3);
            app.C1_filtred=filter_channel(app.C1);
            app.Cz_filtred=filter_channel(app.Cz);
            app.C2_filtred=filter_channel(app.C2);
            app.C4_filtred=filter_channel(app.C4);
            app.C6_filtred=filter_channel(app.C6);
            app.T8_filtred=filter_channel(app.T8);
            app.TP7_filtred=filter_channel(app.TP7);
            app.CP5_filtred=filter_channel(app.CP5);
            app.CP3_filtred=filter_channel(app.CP3);
            app.CP1_filtred=filter_channel(app.CP1);
            app.CPz_filtred=filter_channel(app.CPz);
            app.CP2_filtred=filter_channel(app.CP2);
            app.CP4_filtred=filter_channel(app.CP4);
            app.CP6_filtred=filter_channel(app.CP6);
            app.TP8_filtred=filter_channel(app.TP8);
            app.P7_filtred=filter_channel(app.P7);
            app.P5_filtred=filter_channel(app.P5);
            app.P3_filtred=filter_channel(app.P3);
            app.P1_filtred=filter_channel(app.P1);
            app.Pz_filtred=filter_channel(app.Pz);
            app.P2_filtred=filter_channel(app.P2);
            app.P4_filtred=filter_channel(app.P4);
            app.P6_filtred=filter_channel(app.P6);
            app.P8_filtred=filter_channel(app.P8);
            app.PO7_filtred=filter_channel(app.PO7);
            app.PO3_filtred=filter_channel(app.PO3);
            app.PO4_filtred=filter_channel(app.PO4);
            app.PO8_filtred=filter_channel(app.PO8);
            app.O1_filtred=filter_channel(app.O1);
            app.Oz_filtred=filter_channel(app.Oz);
            app.O2_filtred=filter_channel(app.O2);
            app.HEOGplus_filtred=filter_channel(app.HEOGplus);
            app.HEOG_filtred=filter_channel(app.HEOG);
            app.VEOGplus_filtred=filter_channel(app.VEOGplus);
            app.VEOG_filtred=filter_channel(app.VEOG);
            app.M1_filtred=filter_channel(app.M1);
            
            
            
        end
        
        
        function results = print_tension(app)
            app.estimulo=str2double(app.StimStart)-str2double(app.AudioStart);
            app.final=str2double(app.AudioEnd)-str2double(app.AudioStart);
            
            if app.AudioCode(1)=='2'
                xline(app.UIAxes2,app.estimulo,'--r');hold(app.UIAxes2, 'on');
            end
            xline(app.UIAxes2,app.final,'--g');hold(app.UIAxes2, 'on');
            app.duracion=app.duracion/250;
            set(app.UIAxes2,'XTick',0:250:app.duracion);
            set(app.UIAxes2,'XTickLabel',0:app.duracion);
            xlabel(app.UIAxes2, 'Time (seconds)');
            ylabel(app.UIAxes2, 'Voltage (microvolts)');
%             set(app.UIAxes2,'XLabel','Tiempo (segundos)');
%             set(app.UIAxes2,'YLabel','Voltaje (segundos)');
            if app.Cz_Button.Value == 1
                plot(app.UIAxes2,app.Cz); hold(app.UIAxes2, 'on')
            end
            if app.C2_Button.Value == 1
                plot(app.UIAxes2,app.C2); hold(app.UIAxes2, 'on')
            end
            if app.C4_Button.Value == 1
                plot(app.UIAxes2,app.C4); hold(app.UIAxes2, 'on')
            end
            if app.C6_Button.Value == 1
                plot(app.UIAxes2,app.C6); hold(app.UIAxes2, 'on')
            end
            if app.T8_Button.Value == 1
                plot(app.UIAxes2,app.T8); hold(app.UIAxes2, 'on')
            end
            if app.T7_Button.Value == 1
                plot(app.UIAxes2,app.T7); hold(app.UIAxes2, 'on')
            end
            if app.C5_Button.Value == 1
                plot(app.UIAxes2,app.C5); hold(app.UIAxes2, 'on')
            end
            if app.C3_Button.Value == 1
                plot(app.UIAxes2,app.C3); hold(app.UIAxes2, 'on')
            end
            if app.C1_Button.Value == 1
                plot(app.UIAxes2,app.C1); hold(app.UIAxes2, 'on')
            end
            if app.FCz_Button.Value == 1
                plot(app.UIAxes2,app.FCz); hold(app.UIAxes2, 'on')
            end
            if app.Fz_Button.Value == 1
                plot(app.UIAxes2,app.Fz); hold(app.UIAxes2, 'on')
            end
            %             if app.AFz_Button.Value == 1
            %                 plot(app.UIAxes2,app.AFz); hold(app.UIAxes2, 'on')
            %             end
            if app.Fpz_Button.Value == 1
                plot(app.UIAxes2,app.Fpz); hold(app.UIAxes2, 'on')
            end
            %             if app.FOz_Button.Value == 1
            %                 plot(app.UIAxes2,app.FOz); hold(app.UIAxes2, 'on')
            %             end
            if app.Oz_Button.Value == 1
                plot(app.UIAxes2,app.Oz); hold(app.UIAxes2, 'on')
            end
            %             if app.Iz_Button.Value == 1
            %                 plot(app.UIAxes2,app.Iz); hold(app.UIAxes2, 'on')
            %             end
            if app.Pz_Button.Value == 1
                plot(app.UIAxes2,app.Pz); hold(app.UIAxes2, 'on')
            end
            if app.CPz_Button.Value == 1
                plot(app.UIAxes2,app.CPz); hold(app.UIAxes2, 'on')
            end
            if app.FC1_Button.Value == 1
                plot(app.UIAxes2,app.FC1); hold(app.UIAxes2, 'on')
            end
            if app.FC2_Button.Value == 1
                plot(app.UIAxes2,app.FC2); hold(app.UIAxes2, 'on')
            end
            if app.CP1_Button.Value == 1
                plot(app.UIAxes2,app.CP1); hold(app.UIAxes2, 'on')
            end
            if app.CP2_Button.Value == 1
                plot(app.UIAxes2,app.CP2); hold(app.UIAxes2, 'on')
            end
            if app.FC4_Button.Value == 1
                plot(app.UIAxes2,app.FC4); hold(app.UIAxes2, 'on')
            end
            if app.AF4_Button.Value == 1
                plot(app.UIAxes2,app.AF4); hold(app.UIAxes2, 'on')
            end
            if app.FC6_Button.Value == 1
                plot(app.UIAxes2,app.FC6); hold(app.UIAxes2, 'on')
            end
            if app.FT8_Button.Value == 1
                plot(app.UIAxes2,app.FT8); hold(app.UIAxes2, 'on')
            end
            if app.F2_Button.Value == 1
                plot(app.UIAxes2,app.F2); hold(app.UIAxes2, 'on')
            end
            if app.F4_Button.Value == 1
                plot(app.UIAxes2,app.F4); hold(app.UIAxes2, 'on')
            end
            if app.F6_Button.Value == 1
                plot(app.UIAxes2,app.F6); hold(app.UIAxes2, 'on')
            end
            if app.F8_Button.Value == 1
                plot(app.UIAxes2,app.F8); hold(app.UIAxes2, 'on')
            end
            if app.Fp2_Button.Value == 1
                plot(app.UIAxes2,app.Fp2); hold(app.UIAxes2, 'on')
            end
            if app.F3_Button.Value == 1
                plot(app.UIAxes2,app.F3); hold(app.UIAxes2, 'on')
            end
            if app.F7_Button.Value == 1
                plot(app.UIAxes2,app.F7); hold(app.UIAxes2, 'on')
            end
            if app.F5_Button.Value == 1
                plot(app.UIAxes2,app.F5); hold(app.UIAxes2, 'on')
            end
            if app.AF8_Button.Value == 1
                plot(app.UIAxes2,app.AF8); hold(app.UIAxes2, 'on')
            end
            if app.Fp1_Button.Value == 1
                plot(app.UIAxes2,app.Fp1); hold(app.UIAxes2, 'on')
            end
            if app.AF7_Button.Value == 1
                plot(app.UIAxes2,app.AF7); hold(app.UIAxes2, 'on')
            end
            if app.F1_Button.Value == 1
                plot(app.UIAxes2,app.F1); hold(app.UIAxes2, 'on')
            end
            if app.AF3_Button.Value == 1
                plot(app.UIAxes2,app.AF3); hold(app.UIAxes2, 'on')
            end
            if app.TP7_Button.Value == 1
                plot(app.UIAxes2,app.TP7); hold(app.UIAxes2, 'on')
            end
            if app.FC3_Button.Value == 1
                plot(app.UIAxes2,app.FC3); hold(app.UIAxes2, 'on')
            end
            if app.FC5_Button.Value == 1
                plot(app.UIAxes2,app.FC5); hold(app.UIAxes2, 'on')
            end
            if app.FT7_Button.Value == 1
                plot(app.UIAxes2,app.FT7); hold(app.UIAxes2, 'on')
            end
            if app.CP4_Button.Value == 1
                plot(app.UIAxes2,app.CP4); hold(app.UIAxes2, 'on')
            end
            if app.CP6_Button.Value == 1
                plot(app.UIAxes2,app.CP6); hold(app.UIAxes2, 'on')
            end
            if app.TP8_Button.Value == 1
                plot(app.UIAxes2,app.TP8); hold(app.UIAxes2, 'on')
            end
            if app.P2_Button.Value == 1
                plot(app.UIAxes2,app.P2); hold(app.UIAxes2, 'on')
            end
            if app.P4_Button.Value == 1
                plot(app.UIAxes2,app.P4); hold(app.UIAxes2, 'on')
            end
            if app.P6_Button.Value == 1
                plot(app.UIAxes2,app.P6); hold(app.UIAxes2, 'on')
            end
            if app.P8_Button.Value == 1
                plot(app.UIAxes2,app.P8); hold(app.UIAxes2, 'on')
            end
            if app.PO4_Button.Value == 1
                plot(app.UIAxes2,app.PO4); hold(app.UIAxes2, 'on')
            end
            if app.O2_Button.Value == 1
                plot(app.UIAxes2,app.O2); hold(app.UIAxes2, 'on')
            end
            if app.PO8_Button.Value == 1
                plot(app.UIAxes2,app.PO8); hold(app.UIAxes2, 'on')
            end
            if app.CP3_Button.Value == 1
                plot(app.UIAxes2,app.CP3); hold(app.UIAxes2, 'on')
            end
            if app.CP5_Button.Value == 1
                plot(app.UIAxes2,app.CP5); hold(app.UIAxes2, 'on')
            end
            if app.P1_Button.Value == 1
                plot(app.UIAxes2,app.P1); hold(app.UIAxes2, 'on')
            end
            if app.P3_Button.Value == 1
                plot(app.UIAxes2,app.P3); hold(app.UIAxes2, 'on')
            end
            if app.P5_Button.Value == 1
                plot(app.UIAxes2,app.P5); hold(app.UIAxes2, 'on')
            end
            if app.P7_Button.Value == 1
                plot(app.UIAxes2,app.P7); hold(app.UIAxes2, 'on')
            end
            if app.PO3_Button.Value == 1
                plot(app.UIAxes2,app.PO3); hold(app.UIAxes2, 'on')
            end
            if app.O1_Button.Value == 1
                plot(app.UIAxes2,app.O1); hold(app.UIAxes2, 'on')
            end
            if app.PO7_Button.Value == 1
                plot(app.UIAxes2,app.PO7); hold(app.UIAxes2, 'on')
            end
        end
        
        function results = print_filtred_tension(app)
            
            app.estimulo=str2double(app.StimStart)-str2double(app.AudioStart);
            app.final=str2double(app.AudioEnd)-str2double(app.AudioStart);
            
            if app.AudioCode(1)=='2'
                xline(app.UIAxes2,app.estimulo,'--r');hold(app.UIAxes2, 'on');
            end
            xline(app.UIAxes2,app.final,'--g');hold(app.UIAxes2, 'on');
            app.duracion=app.duracion/250;
            set(app.UIAxes2,'XTick',0:250:app.duracion);
            set(app.UIAxes2,'XTickLabel',0:app.duracion);
            xlabel(app.UIAxes2, 'Time (seconds)');
            ylabel(app.UIAxes2, 'Voltage (microvolts)');
            
            if app.Cz_Button.Value == 1
                plot(app.UIAxes2,app.Cz_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C2_Button.Value == 1
                plot(app.UIAxes2,app.C2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C4_Button.Value == 1
                plot(app.UIAxes2,app.C4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C6_Button.Value == 1
                plot(app.UIAxes2,app.C6_filtred); hold(app.UIAxes2, 'on')
            end
            if app.T8_Button.Value == 1
                plot(app.UIAxes2,app.T8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.T7_Button.Value == 1
                plot(app.UIAxes2,app.T7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C5_Button.Value == 1
                plot(app.UIAxes2,app.C5_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C3_Button.Value == 1
                plot(app.UIAxes2,app.C3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.C1_Button.Value == 1
                plot(app.UIAxes2,app.C1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FCz_Button.Value == 1
                plot(app.UIAxes2,app.FCz_filtred); hold(app.UIAxes2, 'on')
            end
            if app.Fz_Button.Value == 1
                plot(app.UIAxes2,app.Fz_filtred); hold(app.UIAxes2, 'on')
            end
            %             if app.AFz_Button.Value == 1
            %                 plot(app.UIAxes2,app.AFz_filtred); hold(app.UIAxes2, 'on')
            %             end
            if app.Fpz_Button.Value == 1
                plot(app.UIAxes2,app.Fpz_filtred); hold(app.UIAxes2, 'on')
            end
            %             if app.FOz_Button.Value == 1
            %                 plot(app.UIAxes2,app.FOz_filtred); hold(app.UIAxes2, 'on')
            %             end
            if app.Oz_Button.Value == 1
                plot(app.UIAxes2,app.Oz_filtred); hold(app.UIAxes2, 'on')
            end
            %             if app.Iz_Button.Value == 1
            %                 plot(app.UIAxes2,app.Iz_filtred); hold(app.UIAxes2, 'on')
            %             end
            if app.Pz_Button.Value == 1
                plot(app.UIAxes2,app.Pz_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC1_Button.Value == 1
                plot(app.UIAxes2,app.FC1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC2_Button.Value == 1
                plot(app.UIAxes2,app.FC2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP1_Button.Value == 1
                plot(app.UIAxes2,app.CP1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CPz_Button.Value == 1
                plot(app.UIAxes2,app.CPz_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP2_Button.Value == 1
                plot(app.UIAxes2,app.CP2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC4_Button.Value == 1
                plot(app.UIAxes2,app.FC4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.AF4_Button.Value == 1
                plot(app.UIAxes2,app.AF4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC6_Button.Value == 1
                plot(app.UIAxes2,app.FC6_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FT8_Button.Value == 1
                plot(app.UIAxes2,app.FT8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F2_Button.Value == 1
                plot(app.UIAxes2,app.F2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F4_Button.Value == 1
                plot(app.UIAxes2,app.F4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F6_Button.Value == 1
                plot(app.UIAxes2,app.F6_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F8_Button.Value == 1
                plot(app.UIAxes2,app.F8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.Fp2_Button.Value == 1
                plot(app.UIAxes2,app.Fp2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F3_Button.Value == 1
                plot(app.UIAxes2,app.F3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F7_Button.Value == 1
                plot(app.UIAxes2,app.F7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F5_Button.Value == 1
                plot(app.UIAxes2,app.F5_filtred); hold(app.UIAxes2, 'on')
            end
            if app.AF8_Button.Value == 1
                plot(app.UIAxes2,app.AF8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.Fp1_Button.Value == 1
                plot(app.UIAxes2,app.Fp1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.AF7_Button.Value == 1
                plot(app.UIAxes2,app.AF7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.F1_Button.Value == 1
                plot(app.UIAxes2,app.F1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.AF3_Button.Value == 1
                plot(app.UIAxes2,app.AF3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.TP7_Button.Value == 1
                plot(app.UIAxes2,app.TP7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC3_Button.Value == 1
                plot(app.UIAxes2,app.FC3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FC5_Button.Value == 1
                plot(app.UIAxes2,app.FC5_filtred); hold(app.UIAxes2, 'on')
            end
            if app.FT7_Button.Value == 1
                plot(app.UIAxes2,app.FT7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP4_Button.Value == 1
                plot(app.UIAxes2,app.CP4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP6_Button.Value == 1
                plot(app.UIAxes2,app.CP6_filtred); hold(app.UIAxes2, 'on')
            end
            if app.TP8_Button.Value == 1
                plot(app.UIAxes2,app.TP8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P2_Button.Value == 1
                plot(app.UIAxes2,app.P2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P4_Button.Value == 1
                plot(app.UIAxes2,app.P4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P6_Button.Value == 1
                plot(app.UIAxes2,app.P6_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P8_Button.Value == 1
                plot(app.UIAxes2,app.P8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.PO4_Button.Value == 1
                plot(app.UIAxes2,app.PO4_filtred); hold(app.UIAxes2, 'on')
            end
            if app.O2_Button.Value == 1
                plot(app.UIAxes2,app.O2_filtred); hold(app.UIAxes2, 'on')
            end
            if app.PO8_Button.Value == 1
                plot(app.UIAxes2,app.PO8_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP3_Button.Value == 1
                plot(app.UIAxes2,app.CP3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.CP5_Button.Value == 1
                plot(app.UIAxes2,app.CP5_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P1_Button.Value == 1
                plot(app.UIAxes2,app.P1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P3_Button.Value == 1
                plot(app.UIAxes2,app.P3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P5_Button.Value == 1
                plot(app.UIAxes2,app.P5_filtred); hold(app.UIAxes2, 'on')
            end
            if app.P7_Button.Value == 1
                plot(app.UIAxes2,app.P7_filtred); hold(app.UIAxes2, 'on')
            end
            if app.PO3_Button.Value == 1
                plot(app.UIAxes2,app.PO3_filtred); hold(app.UIAxes2, 'on')
            end
            if app.O1_Button.Value == 1
                plot(app.UIAxes2,app.O1_filtred); hold(app.UIAxes2, 'on')
            end
            if app.PO7_Button.Value == 1
                plot(app.UIAxes2,app.PO7_filtred); hold(app.UIAxes2, 'on')
            end
        end
        
        function results = print_histogram(app)
            
            app.legend= categorical();
            app.signals_ploted=[];
            
            app.estimulo=str2double(app.StimStart)-str2double(app.AudioStart);
            app.final=str2double(app.AudioEnd)-str2double(app.AudioStart);
            
            xlabel(app.UIAxes2, 'Channel');
            ylabel(app.UIAxes2, 'Voltage (microvolts)');
            
            if app.Fpz_Button.Value == 1
                app.legend = [app.legend categorical({'Fpz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fpz)];
            end
            if app.Fp1_Button.Value == 1
                app.legend = [app.legend categorical({'Fp1'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fp1)];
            end
            if app.Fp2_Button.Value == 1
                app.legend = [app.legend categorical({'Fp2'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fp2)];
            end
            if app.AF7_Button.Value == 1
                app.legend = [app.legend categorical({'AF7'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF7)];
            end
            if app.AF3_Button.Value == 1
                app.legend = [app.legend categorical({'AF3'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF3)];
            end
            if app.AF4_Button.Value == 1
                app.legend = [app.legend categorical({'AF4'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF4)];
            end
            if app.AF8_Button.Value == 1
                app.legend = [app.legend categorical({'AF8'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF8)];
            end
            if app.F7_Button.Value == 1
                app.legend = [app.legend categorical({'F7'})];
                app.signals_ploted = [app.signals_ploted mean(app.F7)];
            end
            if app.F5_Button.Value == 1
                app.legend = [app.legend categorical({'F5'})];
                app.signals_ploted = [app.signals_ploted mean(app.F5)];
            end
            if app.F3_Button.Value == 1
                app.legend = [app.legend categorical({'F3'})];
                app.signals_ploted = [app.signals_ploted mean(app.F3)];
            end
            
            if app.F1_Button.Value == 1
                app.legend = [app.legend categorical({'F1'})];
                app.signals_ploted = [app.signals_ploted mean(app.F1)];
            end
            if app.Fz_Button.Value == 1
                app.legend = [app.legend categorical({'Fz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fz)];
            end
            if app.F2_Button.Value == 1
                app.legend = [app.legend categorical({'F2'})];
                app.signals_ploted = [app.signals_ploted mean(app.F2)];
            end
            if app.F4_Button.Value == 1
                app.legend = [app.legend categorical({'F4'})];
                app.signals_ploted = [app.signals_ploted mean(app.F4)];
            end
            if app.F6_Button.Value == 1
                app.legend = [app.legend categorical({'F6'})];
                app.signals_ploted = [app.signals_ploted mean(app.F6)];
            end
            if app.F8_Button.Value == 1
                app.legend = [app.legend categorical({'F8'})];
                app.signals_ploted = [app.signals_ploted mean(app.F8)];
            end
            if app.FT7_Button.Value == 1
                app.legend = [app.legend categorical({'FT7'})];
                app.signals_ploted = [app.signals_ploted mean(app.FT7)];
            end
            if app.FC5_Button.Value == 1
                app.legend = [app.legend categorical({'FC5'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC5)];
            end
            
            if app.FC3_Button.Value == 1
                app.legend = [app.legend categorical({'FC3'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC3)];
            end
            if app.FC1_Button.Value == 1
                app.legend = [app.legend categorical({'FC1'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC1)];
            end
            if app.FCz_Button.Value == 1
                app.legend = [app.legend categorical({'FCz'})];
                app.signals_ploted = [app.signals_ploted mean(app.FCz)];
            end
            
            if app.FC2_Button.Value == 1
                app.legend = [app.legend categorical({'FC2'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC2)];
            end
            if app.FC4_Button.Value == 1
                app.legend = [app.legend categorical({'FC4'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC4)];
            end
            if app.FC6_Button.Value == 1
                app.legend = [app.legend categorical({'FC6'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC6)];
            end
            if app.FT8_Button.Value == 1
                app.legend = [app.legend categorical({'FT8'})];
                app.signals_ploted = [app.signals_ploted mean(app.FT8)];
            end
            if app.T7_Button.Value == 1
                app.legend = [app.legend categorical({'T7'})];
                app.signals_ploted = [app.signals_ploted mean(app.T7)];
            end
            if app.C5_Button.Value == 1
                app.legend = [app.legend categorical({'C5'})];
                app.signals_ploted = [app.signals_ploted mean(app.C5)];
            end
            if app.C3_Button.Value == 1
                app.legend = [app.legend categorical({'C3'})];
                app.signals_ploted = [app.signals_ploted mean(app.C3)];
            end
            if app.C1_Button.Value == 1
                app.legend = [app.legend categorical({'C1'})];
                app.signals_ploted = [app.signals_ploted mean(app.C1)];
            end      
            if app.Cz_Button.Value == 1
                app.legend = [app.legend categorical({'Cz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Cz)];
            end
            if app.C2_Button.Value == 1
                app.legend = [app.legend categorical({'C2'})];
                app.signals_ploted = [app.signals_ploted mean(app.C2)];
            end
            if app.C4_Button.Value == 1
                app.legend = [app.legend categorical({'C4'})];
                app.signals_ploted = [app.signals_ploted mean(app.C4)];
            end
            if app.C6_Button.Value == 1
                app.legend = [app.legend categorical({'C6'})];
                app.signals_ploted = [app.signals_ploted mean(app.C6)];
            end
            if app.T8_Button.Value == 1
                app.legend = [app.legend categorical({'T8'})];
                app.signals_ploted = [app.signals_ploted mean(app.T8)];
            end
            if app.TP7_Button.Value == 1
                app.legend = [app.legend categorical({'TP7'})];
                app.signals_ploted = [app.signals_ploted mean(app.TP7)];
            end
            if app.CP5_Button.Value == 1
                app.legend = [app.legend categorical({'CP5'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP5)];
            end
            if app.CP3_Button.Value == 1
                app.legend = [app.legend categorical({'CP3'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP3)];
            end
            if app.CP1_Button.Value == 1
                app.legend = [app.legend categorical({'CP1'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP1)];
            end
            if app.CPz_Button.Value == 1
                app.legend = [app.legend categorical({'CPz'})];
                app.signals_ploted = [app.signals_ploted mean(app.CPz)];
            end
            
            if app.CP2_Button.Value == 1
                app.legend = [app.legend categorical({'CP2'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP2)];
            end
            if app.CP4_Button.Value == 1
                app.legend = [app.legend categorical({'CP4'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP4)];
            end
            if app.CP6_Button.Value == 1
                app.legend = [app.legend categorical({'CP6'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP6)];
            end
            if app.TP8_Button.Value == 1
                app.legend = [app.legend categorical({'TP8'})];
                app.signals_ploted = [app.signals_ploted mean(app.TP8)];
            end
            if app.P7_Button.Value == 1
                app.legend = [app.legend categorical({'P7'})];
                app.signals_ploted = [app.signals_ploted mean(app.P7)];
            end
            if app.P5_Button.Value == 1
                app.legend = [app.legend categorical({'P5'})];
                app.signals_ploted = [app.signals_ploted mean(app.P5)];
            end
            if app.P3_Button.Value == 1
                app.legend = [app.legend categorical({'P3'})];
                app.signals_ploted = [app.signals_ploted mean(app.P3)];
            end            
            if app.P1_Button.Value == 1
                app.legend = [app.legend categorical({'P1'})];
                app.signals_ploted = [app.signals_ploted mean(app.P1)];
            end
            if app.Pz_Button.Value == 1
                app.legend = [app.legend categorical({'Pz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Pz)];
            end
            if app.P2_Button.Value == 1
                app.legend = [app.legend categorical({'P2'})];
                app.signals_ploted = [app.signals_ploted mean(app.P2)];
            end
            if app.P4_Button.Value == 1
                app.legend = [app.legend categorical({'P4'})];
                app.signals_ploted = [app.signals_ploted mean(app.P4)];
            end
            if app.P6_Button.Value == 1
                app.legend = [app.legend categorical({'P6'})];
                app.signals_ploted = [app.signals_ploted mean(app.P6)];
            end
            if app.P8_Button.Value == 1
                app.legend = [app.legend categorical({'P8'})];
                app.signals_ploted = [app.signals_ploted mean(app.P8)];
            end
            if app.PO7_Button.Value == 1
                app.legend = [app.legend categorical({'PO7'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO7)];
            end
            if app.PO3_Button.Value == 1
                app.legend = [app.legend categorical({'PO3'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO3)];
            end
            if app.PO4_Button.Value == 1
                app.legend = [app.legend categorical({'PO4'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO4)];
            end
            if app.PO8_Button.Value == 1
                app.legend = [app.legend categorical({'PO8'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO8)];
            end
            if app.O1_Button.Value == 1
                app.legend = [app.legend categorical({'O1'})];
                app.signals_ploted = [app.signals_ploted mean(app.O1)];
            end
            if app.Oz_Button.Value == 1
                app.legend = [app.legend categorical({'Oz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Oz)];
            end
            if app.O2_Button.Value == 1
                app.legend = [app.legend categorical({'O2'})];
                app.signals_ploted = [app.signals_ploted mean(app.O2)];
            end

            
            
            
            
            %             if app.AFz_Button.Value == 1
            %                 plot(app.UIAxes2,app.AFz); hold(app.UIAxes2, 'on')
            %             end
            %             if app.FOz_Button.Value == 1
            %                 plot(app.UIAxes2,app.FOz); hold(app.UIAxes2, 'on')
            %             end
            %             if app.Iz_Button.Value == 1
            %                 plot(app.UIAxes2,app.Iz); hold(app.UIAxes2, 'on')
            %             end
            if ~isempty(app.signals_ploted)
                bar(app.UIAxes2,app.legend,app.signals_ploted);
            else
                app.UIAxes2.cla
            end
%             h = figure;
%             h.Visible = 'off';
%             bar(app.legend,app.signals_ploted);
%             hora=datestr(now,'HH:MM:SS');
%             FileName=['proj',datestr(now, 'dd-mmm-yyyy'),hora(1:2),'-',hora(4:5),'-',hora(7:8),'.png'];
%             saveas(h,FileName);
            
        end
        
        function results = print_filtred_histogram(app)
            
            app.legend= categorical();
            app.signals_ploted=[];
            
            if app.Fpz_Button.Value == 1
                app.legend = [app.legend categorical({'Fpz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fpz_filtred)];
            end
            if app.Fp1_Button.Value == 1
                app.legend = [app.legend categorical({'Fp1'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fp1_filtred)];
            end
            if app.Fp2_Button.Value == 1
                app.legend = [app.legend categorical({'Fp2'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fp2_filtred)];
            end
            if app.AF7_Button.Value == 1
                app.legend = [app.legend categorical({'AF7'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF7_filtred)];
            end
            if app.AF3_Button.Value == 1
                app.legend = [app.legend categorical({'AF3'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF3_filtred)];
            end
            if app.AF4_Button.Value == 1
                app.legend = [app.legend categorical({'AF4'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF4_filtred)];
            end
            if app.AF8_Button.Value == 1
                app.legend = [app.legend categorical({'AF8'})];
                app.signals_ploted = [app.signals_ploted mean(app.AF8_filtred)];
            end
            if app.F7_Button.Value == 1
                app.legend = [app.legend categorical({'F7'})];
                app.signals_ploted = [app.signals_ploted mean(app.F7_filtred)];
            end
            if app.F5_Button.Value == 1
                app.legend = [app.legend categorical({'F5'})];
                app.signals_ploted = [app.signals_ploted mean(app.F5_filtred)];
            end
            if app.F3_Button.Value == 1
                app.legend = [app.legend categorical({'F3'})];
                app.signals_ploted = [app.signals_ploted mean(app.F3_filtred)];
            end
            
            if app.F1_Button.Value == 1
                app.legend = [app.legend categorical({'F1'})];
                app.signals_ploted = [app.signals_ploted mean(app.F1_filtred)];
            end
            if app.Fz_Button.Value == 1
                app.legend = [app.legend categorical({'Fz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Fz_filtred)];
            end
            if app.F2_Button.Value == 1
                app.legend = [app.legend categorical({'F2'})];
                app.signals_ploted = [app.signals_ploted mean(app.F2_filtred)];
            end
            if app.F4_Button.Value == 1
                app.legend = [app.legend categorical({'F4'})];
                app.signals_ploted = [app.signals_ploted mean(app.F4_filtred)];
            end
            if app.F6_Button.Value == 1
                app.legend = [app.legend categorical({'F6'})];
                app.signals_ploted = [app.signals_ploted mean(app.F6_filtred)];
            end
            if app.F8_Button.Value == 1
                app.legend = [app.legend categorical({'F8'})];
                app.signals_ploted = [app.signals_ploted mean(app.F8_filtred)];
            end
            if app.FT7_Button.Value == 1
                app.legend = [app.legend categorical({'FT7'})];
                app.signals_ploted = [app.signals_ploted mean(app.FT7_filtred)];
            end
            if app.FC5_Button.Value == 1
                app.legend = [app.legend categorical({'FC5'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC5_filtred)];
            end
            
            if app.FC3_Button.Value == 1
                app.legend = [app.legend categorical({'FC3'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC3_filtred)];
            end
            if app.FC1_Button.Value == 1
                app.legend = [app.legend categorical({'FC1'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC1_filtred)];
            end
            if app.FCz_Button.Value == 1
                app.legend = [app.legend categorical({'FCz'})];
                app.signals_ploted = [app.signals_ploted mean(app.FCz_filtred)];
            end
            
            if app.FC2_Button.Value == 1
                app.legend = [app.legend categorical({'FC2'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC2_filtred)];
            end
            if app.FC4_Button.Value == 1
                app.legend = [app.legend categorical({'FC4'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC4_filtred)];
            end
            if app.FC6_Button.Value == 1
                app.legend = [app.legend categorical({'FC6'})];
                app.signals_ploted = [app.signals_ploted mean(app.FC6_filtred)];
            end
            if app.FT8_Button.Value == 1
                app.legend = [app.legend categorical({'FT8'})];
                app.signals_ploted = [app.signals_ploted mean(app.FT8_filtred)];
            end
            if app.T7_Button.Value == 1
                app.legend = [app.legend categorical({'T7'})];
                app.signals_ploted = [app.signals_ploted mean(app.T7_filtred)];
            end
            if app.C5_Button.Value == 1
                app.legend = [app.legend categorical({'C5'})];
                app.signals_ploted = [app.signals_ploted mean(app.C5_filtred)];
            end
            if app.C3_Button.Value == 1
                app.legend = [app.legend categorical({'C3'})];
                app.signals_ploted = [app.signals_ploted mean(app.C3_filtred)];
            end
            if app.C1_Button.Value == 1
                app.legend = [app.legend categorical({'C1'})];
                app.signals_ploted = [app.signals_ploted mean(app.C1_filtred)];
            end
            if app.Cz_Button.Value == 1
                app.legend = [app.legend categorical({'Cz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Cz_filtred)];
            end
            if app.C2_Button.Value == 1
                app.legend = [app.legend categorical({'C2'})];
                app.signals_ploted = [app.signals_ploted mean(app.C2_filtred)];
            end
            if app.C4_Button.Value == 1
                app.legend = [app.legend categorical({'C4'})];
                app.signals_ploted = [app.signals_ploted mean(app.C4_filtred)];
            end
            if app.C6_Button.Value == 1
                app.legend = [app.legend categorical({'C6'})];
                app.signals_ploted = [app.signals_ploted mean(app.C6_filtred)];
            end
            if app.T8_Button.Value == 1
                app.legend = [app.legend categorical({'T8'})];
                app.signals_ploted = [app.signals_ploted mean(app.T8_filtred)];
            end
            if app.TP7_Button.Value == 1
                app.legend = [app.legend categorical({'TP7'})];
                app.signals_ploted = [app.signals_ploted mean(app.TP7_filtred)];
            end
            if app.CP5_Button.Value == 1
                app.legend = [app.legend categorical({'CP5'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP5_filtred)];
            end
            if app.CP3_Button.Value == 1
                app.legend = [app.legend categorical({'CP3'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP3_filtred)];
            end
            if app.CP1_Button.Value == 1
                app.legend = [app.legend categorical({'CP1'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP1_filtred)];
            end
            if app.CPz_Button.Value == 1
                app.legend = [app.legend categorical({'CPz'})];
                app.signals_ploted = [app.signals_ploted mean(app.CPz_filtred)];
            end
            
            if app.CP2_Button.Value == 1
                app.legend = [app.legend categorical({'CP2'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP2_filtred)];
            end
            if app.CP4_Button.Value == 1
                app.legend = [app.legend categorical({'CP4'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP4_filtred)];
            end
            if app.CP6_Button.Value == 1
                app.legend = [app.legend categorical({'CP6'})];
                app.signals_ploted = [app.signals_ploted mean(app.CP6_filtred)];
            end
            if app.TP8_Button.Value == 1
                app.legend = [app.legend categorical({'TP8'})];
                app.signals_ploted = [app.signals_ploted mean(app.TP8_filtred)];
            end
            if app.P7_Button.Value == 1
                app.legend = [app.legend categorical({'P7'})];
                app.signals_ploted = [app.signals_ploted mean(app.P7_filtred)];
            end
            if app.P5_Button.Value == 1
                app.legend = [app.legend categorical({'P5'})];
                app.signals_ploted = [app.signals_ploted mean(app.P5_filtred)];
            end
            if app.P3_Button.Value == 1
                app.legend = [app.legend categorical({'P3'})];
                app.signals_ploted = [app.signals_ploted mean(app.P3_filtred)];
            end
            if app.P1_Button.Value == 1
                app.legend = [app.legend categorical({'P1'})];
                app.signals_ploted = [app.signals_ploted mean(app.P1_filtred)];
            end
            if app.Pz_Button.Value == 1
                app.legend = [app.legend categorical({'Pz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Pz_filtred)];
            end
            if app.P2_Button.Value == 1
                app.legend = [app.legend categorical({'P2'})];
                app.signals_ploted = [app.signals_ploted mean(app.P2_filtred)];
            end
            if app.P4_Button.Value == 1
                app.legend = [app.legend categorical({'P4'})];
                app.signals_ploted = [app.signals_ploted mean(app.P4_filtred)];
            end
            if app.P6_Button.Value == 1
                app.legend = [app.legend categorical({'P6'})];
                app.signals_ploted = [app.signals_ploted mean(app.P6_filtred)];
            end
            if app.P8_Button.Value == 1
                app.legend = [app.legend categorical({'P8'})];
                app.signals_ploted = [app.signals_ploted mean(app.P8_filtred)];
            end
            if app.PO7_Button.Value == 1
                app.legend = [app.legend categorical({'PO7'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO7_filtred)];
            end
            if app.PO3_Button.Value == 1
                app.legend = [app.legend categorical({'PO3'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO3_filtred)];
            end
            if app.PO4_Button.Value == 1
                app.legend = [app.legend categorical({'PO4'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO4_filtred)];
            end
            if app.PO8_Button.Value == 1
                app.legend = [app.legend categorical({'PO8'})];
                app.signals_ploted = [app.signals_ploted mean(app.PO8_filtred)];
            end
            if app.O1_Button.Value == 1
                app.legend = [app.legend categorical({'O1'})];
                app.signals_ploted = [app.signals_ploted mean(app.O1_filtred)];
            end
            if app.Oz_Button.Value == 1
                app.legend = [app.legend categorical({'Oz'})];
                app.signals_ploted = [app.signals_ploted mean(app.Oz_filtred)];
            end
            if app.O2_Button.Value == 1
                app.legend = [app.legend categorical({'O2'})];
                app.signals_ploted = [app.signals_ploted mean(app.O2_filtred)];
            end
            if ~isempty(app.signals_ploted)
                bar(app.UIAxes2,app.legend,app.signals_ploted);
            else
                app.UIAxes2.cla
            end
        end
        
        function [entropy,prob] =  myentropy(app,hist)
            totalprob=sum(hist);
            prob=zeros(1,length(hist));
            entropy=0;
            for i=1:length(hist)
                prob(i)=arg(i)/totalprob;
                if prob(i)==0
                    continue
                end
                entropy = entropy -(prob(i)*log2(prob(i)));
            end
            
         end
        
        
        function hist = myproces(~,channel)
            an_sig=hilbert(channel);
            my_angle=angle(an_sig);
            hist=histcounts(my_angle, [-pi, -pi/2, 0, pi/2, pi]);
            hist=hist(1:4);
        end
        
        function results = myMI(~,entropy1,~,prob1,prob2)
            KL=0;
            for p=1:length(prob1)
                for q=1:length(prob2)
                    KL=KL+(prob1(p)*log2(prob1(p)/prob2(q)));
                end
            end
            MI=entropy1+KL;
            results=MI;
        end
        
        function results = createFigure(app)
            switch app.ShowDropDown.Value
                case 'Tension signal'
                    % Create new figure and new axes
                    app.myFigure = figure;
                    app.myFigure.Visible = 'off';
                    axNew = axes;
                    % Copy all opjects from UIAxes to new axis
                    copyobj(app.UIAxes2.Children, axNew);
                    % Save all parameters of the UIAxes
                    uiAxParams = get(app.UIAxes2);
                    uiAxParamNames = fieldnames(uiAxParams);
                    % Get list of editable params in new axis
                    editableParams = fieldnames(set(axNew));
                    % Remove the UIAxes params that aren't editable in the new axes (add others you don't want)
                    badFields = uiAxParamNames(~ismember(uiAxParamNames, editableParams));
                    badFields = [badFields; 'Parent'; 'Children'; 'XAxis'; 'YAxis'; 'ZAxis';'Position';'OuterPosition'];
                    uiAxGoodParams = rmfield(uiAxParams,badFields);
                    % set editable params on new axes
                    set(axNew, uiAxGoodParams)
                    app.type= 'Tension signal ';
                case 'Mean values'
                    app.myFigure = figure;
                    app.myFigure.Visible = 'off';
                    bar(app.legend,app.signals_ploted);
                    app.type= 'Histogram ';
            end
        end
        
        function reportName = typeIntoXslx(app)
            hora=datestr(now,'HH:MM:SS');
            mkdir('reports/excel');
            getname(app);
            FileName=[datestr(now, 'dd-mmm-yyyy'),' ',hora(1:2),'-',hora(4:5),'-',hora(7:8), ' ',app.myFileName];
            reportName=[FileName, '.xlsx'];
            FileName=['reports/excel/' FileName];
            FileName=[FileName, '.xlsx'];
            
            myText={'Channel' 'MI'};
            
            if app.filter==0
                if app.Fpz_Button.Value == 1
                    MI=obtainMI(app,app.Fpz);
                    myText=vertcat(myText ,{'Fpz' MI});
                end
                if app.Fp1_Button.Value == 1
                    MI=obtainMI(app,app.Fp1);
                    myText=vertcat(myText ,{'Fp1', MI});
                end
                if app.Fp2_Button.Value == 1
                    MI=obtainMI(app,app.Fp2);
                    myText=vertcat(myText ,{'Fp2' MI});
                end
                if app.AF7_Button.Value == 1
                    MI=obtainMI(app,app.AF7);
                    myText=vertcat(myText ,{'AF7' MI});
                end
                if app.AF3_Button.Value == 1
                    MI=obtainMI(app,app.AF3);
                    myText=vertcat(myText ,{'AF3' MI});
                end
                if app.AF4_Button.Value == 1
                    MI=obtainMI(app,app.AF4);
                    myText=vertcat(myText ,{'AF4' MI});
                end
                if app.AF8_Button.Value == 1
                    MI=obtainMI(app,app.AF8);
                    myText=vertcat(myText ,{'AF8' MI});
                end
                if app.F7_Button.Value == 1
                    MI=obtainMI(app,app.F7);
                    myText=vertcat(myText ,{'F7' MI});
                end
                if app.F5_Button.Value == 1
                    MI=obtainMI(app,app.F5);
                    myText=vertcat(myText ,{'F5' MI});
                end
                if app.F3_Button.Value == 1
                    MI=obtainMI(app,app.F3);
                    myText=vertcat(myText ,{'F3' MI});
                end
                
                if app.F1_Button.Value == 1
                    MI=obtainMI(app,app.F1);
                    myText=vertcat(myText ,{'F1' MI});
                end
                if app.Fz_Button.Value == 1
                    MI=obtainMI(app,app.Fz);
                    myText=vertcat(myText ,{'Fz' MI});
                end
                if app.F2_Button.Value == 1
                    MI=obtainMI(app,app.F2);
                    myText=vertcat(myText ,{'F2' MI});
                end
                if app.F4_Button.Value == 1
                    MI=obtainMI(app,app.F4);
                    myText=vertcat(myText ,{'F4' MI});
                end
                if app.F6_Button.Value == 1
                    MI=obtainMI(app,app.F6);
                    myText=vertcat(myText ,{'F6' MI});
                end
                if app.F8_Button.Value == 1
                    MI=obtainMI(app,app.F8);
                    myText=vertcat(myText ,{'F8' MI});
                end
                if app.FT7_Button.Value == 1
                    MI=obtainMI(app,app.FT7);
                    myText=vertcat(myText ,{'FT7' MI});
                end
                if app.FC5_Button.Value == 1
                    MI=obtainMI(app,app.FC5);
                    myText=vertcat(myText ,{'FC5' MI});
                end
                
                if app.FC3_Button.Value == 1
                    MI=obtainMI(app,app.FC3);
                    myText=vertcat(myText ,{'FC3' MI});
                end
                if app.FC1_Button.Value == 1
                    MI=obtainMI(app,app.FC1);
                    myText=vertcat(myText ,{'FC1' MI});
                end
                if app.FCz_Button.Value == 1
                    MI=obtainMI(app,app.FCz);
                    myText=vertcat(myText ,{'FCz' MI});
                end
                
                if app.FC2_Button.Value == 1
                    MI=obtainMI(app,app.FC2);
                    myText=vertcat(myText ,{'FC2' MI});
                end
                if app.FC4_Button.Value == 1
                    MI=obtainMI(app,app.FC4);
                    myText=vertcat(myText ,{'FC4' MI});
                end
                if app.FC6_Button.Value == 1
                    MI=obtainMI(app,app.FC6);
                    myText=vertcat(myText ,{'FC6' MI});
                end
                if app.FT8_Button.Value == 1
                    MI=obtainMI(app,app.FT8);
                    myText=vertcat(myText ,{'FT8' MI});
                end
                if app.T7_Button.Value == 1
                    MI=obtainMI(app,app.T7);
                    myText=vertcat(myText ,{'T7' MI});
                end
                if app.C5_Button.Value == 1
                    MI=obtainMI(app,app.C5);
                    myText=vertcat(myText ,{'C5' MI});
                end
                if app.C3_Button.Value == 1
                    MI=obtainMI(app,app.C3);
                    myText=vertcat(myText ,{'C3' MI});
                end
                if app.C1_Button.Value == 1
                    MI=obtainMI(app,app.C1);
                    myText=vertcat(myText ,{'C1' MI});
                end
                if app.Cz_Button.Value == 1
                    MI=obtainMI(app,app.Cz);
                    myText=vertcat(myText ,{'Cz' MI});
                end
                if app.C2_Button.Value == 1
                    MI=obtainMI(app,app.C2);
                    myText=vertcat(myText ,{'C2' MI});
                end
                if app.C4_Button.Value == 1
                    MI=obtainMI(app,app.C4);
                    myText=vertcat(myText ,{'C4' MI});
                end
                if app.C6_Button.Value == 1
                    MI=obtainMI(app,app.C6);
                    myText=vertcat(myText ,{'C6' MI});
                end
                if app.T8_Button.Value == 1
                    MI=obtainMI(app,app.T8);
                    myText=vertcat(myText ,{'T8' MI});
                end
                if app.TP7_Button.Value == 1
                    MI=obtainMI(app,app.TP7);
                    myText=vertcat(myText ,{'TP7' MI});
                end
                if app.CP5_Button.Value == 1
                    MI=obtainMI(app,app.CP5);
                    myText=vertcat(myText ,{'CP5' MI});
                end
                if app.CP3_Button.Value == 1
                    MI=obtainMI(app,app.CP3);
                    myText=vertcat(myText ,{'CP3' MI});
                end
                if app.CP1_Button.Value == 1
                    MI=obtainMI(app,app.CP1);
                    myText=vertcat(myText ,{'CP1' MI});
                end
                if app.CPz_Button.Value == 1
                    MI=obtainMI(app,app.CPz);
                    myText=vertcat(myText ,{'CPz' MI});
                end
                
                if app.CP2_Button.Value == 1
                    MI=obtainMI(app,app.CP2);
                    myText=vertcat(myText ,{'CP2' MI});
                end
                if app.CP4_Button.Value == 1
                    MI=obtainMI(app,app.CP4);
                    myText=vertcat(myText ,{'CP4' MI});
                end
                if app.CP6_Button.Value == 1
                    MI=obtainMI(app,app.CP6);
                    myText=vertcat(myText ,{'CP6' MI});
                end
                if app.TP8_Button.Value == 1
                    MI=obtainMI(app,app.TP8);
                    myText=vertcat(myText ,{'TP8' MI});
                end
                if app.P7_Button.Value == 1
                    MI=obtainMI(app,app.P7);
                    myText=vertcat(myText ,{'P7' MI});
                end
                if app.P5_Button.Value == 1
                    MI=obtainMI(app,app.P5);
                    myText=vertcat(myText ,{'P5' MI});
                end
                if app.P3_Button.Value == 1
                    MI=obtainMI(app,app.P3);
                    myText=vertcat(myText ,{'P3' MI});
                end
                if app.P1_Button.Value == 1
                    MI=obtainMI(app,app.P1);
                    myText=vertcat(myText ,{'P1' MI});
                end
                if app.Pz_Button.Value == 1
                    MI=obtainMI(app,app.Pz);
                    myText=vertcat(myText ,{'Pz' MI});
                end
                if app.P2_Button.Value == 1
                    MI=obtainMI(app,app.P2);
                    myText=vertcat(myText ,{'P2' MI});
                end
                if app.P4_Button.Value == 1
                    MI=obtainMI(app,app.P4);
                    myText=vertcat(myText ,{'P4' MI});
                end
                if app.P6_Button.Value == 1
                    MI=obtainMI(app,app.P6);
                    myText=vertcat(myText ,{'P6' MI});
                end
                if app.P8_Button.Value == 1
                    MI=obtainMI(app,app.P8);
                    myText=vertcat(myText ,{'P8' MI});
                end
                if app.PO7_Button.Value == 1
                    MI=obtainMI(app,app.PO7);
                    myText=vertcat(myText ,{'PO7' MI});
                end
                if app.PO3_Button.Value == 1
                    MI=obtainMI(app,app.PO3);
                    myText=vertcat(myText ,{'PO3' MI});
                end
                if app.PO4_Button.Value == 1
                    MI=obtainMI(app,app.PO4);
                    myText=vertcat(myText ,{'PO4' MI});
                end
                if app.PO8_Button.Value == 1
                    MI=obtainMI(app,app.PO8);
                    myText=vertcat(myText ,{'PO8' MI});
                end
                if app.O1_Button.Value == 1
                    MI=obtainMI(app,app.O1);
                    myText=vertcat(myText ,{'O1' MI});
                end
                if app.Oz_Button.Value == 1
                    MI=obtainMI(app,app.Oz);
                    myText=vertcat(myText ,{'Oz' MI});
                end
                if app.O2_Button.Value == 1
                    MI=obtainMI(app,app.O2);
                    myText=vertcat(myText ,{'O2' MI});
                end
            else
                if app.Fpz_Button.Value == 1
                    MI=obtainMI(app,app.Fpz_filtred);
                    myText=vertcat(myText ,{'Fpz' MI});
                end
                if app.Fp1_Button.Value == 1
                    MI=obtainMI(app,app.Fp1_filtred);
                    myText=vertcat(myText ,{'Fp1', MI});
                end
                if app.Fp2_Button.Value == 1
                    MI=obtainMI(app,app.Fp2_filtred);
                    myText=vertcat(myText ,{'Fp2' MI});
                end
                if app.AF7_Button.Value == 1
                    MI=obtainMI(app,app.AF7_filtred);
                    myText=vertcat(myText ,{'AF7' MI});
                end
                if app.AF3_Button.Value == 1
                    MI=obtainMI(app,app.AF3_filtred);
                    myText=vertcat(myText ,{'AF3' MI});
                end
                if app.AF4_Button.Value == 1
                    MI=obtainMI(app,app.AF4_filtred);
                    myText=vertcat(myText ,{'AF4' MI});
                end
                if app.AF8_Button.Value == 1
                    MI=obtainMI(app,app.AF8_filtred);
                    myText=vertcat(myText ,{'AF8' MI});
                end
                if app.F7_Button.Value == 1
                    MI=obtainMI(app,app.F7_filtred);
                    myText=vertcat(myText ,{'F7' MI});
                end
                if app.F5_Button.Value == 1
                    MI=obtainMI(app,app.F5_filtred);
                    myText=vertcat(myText ,{'F5' MI});
                end
                if app.F3_Button.Value == 1
                    MI=obtainMI(app,app.F3_filtred);
                    myText=vertcat(myText ,{'F3' MI});
                end
                
                if app.F1_Button.Value == 1
                    MI=obtainMI(app,app.F1_filtred);
                    myText=vertcat(myText ,{'F1' MI});
                end
                if app.Fz_Button.Value == 1
                    MI=obtainMI(app,app.Fz_filtred);
                    myText=vertcat(myText ,{'Fz' MI});
                end
                if app.F2_Button.Value == 1
                    MI=obtainMI(app,app.F2_filtred);
                    myText=vertcat(myText ,{'F2' MI});
                end
                if app.F4_Button.Value == 1
                    MI=obtainMI(app,app.F4_filtred);
                    myText=vertcat(myText ,{'F4' MI});
                end
                if app.F6_Button.Value == 1
                    MI=obtainMI(app,app.F6_filtred);
                    myText=vertcat(myText ,{'F6' MI});
                end
                if app.F8_Button.Value == 1
                    MI=obtainMI(app,app.F8_filtred);
                    myText=vertcat(myText ,{'F8' MI});
                end
                if app.FT7_Button.Value == 1
                    MI=obtainMI(app,app.FT7_filtred);
                    myText=vertcat(myText ,{'FT7' MI});
                end
                if app.FC5_Button.Value == 1
                    MI=obtainMI(app,app.FC5_filtred);
                    myText=vertcat(myText ,{'FC5' MI});
                end
                
                if app.FC3_Button.Value == 1
                    MI=obtainMI(app,app.FC3_filtred);
                    myText=vertcat(myText ,{'FC3' MI});
                end
                if app.FC1_Button.Value == 1
                    MI=obtainMI(app,app.FC1_filtred);
                    myText=vertcat(myText ,{'FC1' MI});
                end
                if app.FCz_Button.Value == 1
                    MI=obtainMI(app,app.FCz_filtred);
                    myText=vertcat(myText ,{'FCz' MI});
                end
                
                if app.FC2_Button.Value == 1
                    MI=obtainMI(app,app.FC2_filtred);
                    myText=vertcat(myText ,{'FC2' MI});
                end
                if app.FC4_Button.Value == 1
                    MI=obtainMI(app,app.FC4_filtred);
                    myText=vertcat(myText ,{'FC4' MI});
                end
                if app.FC6_Button.Value == 1
                    MI=obtainMI(app,app.FC6_filtred);
                    myText=vertcat(myText ,{'FC6' MI});
                end
                if app.FT8_Button.Value == 1
                    MI=obtainMI(app,app.FT8_filtred);
                    myText=vertcat(myText ,{'FT8' MI});
                end
                if app.T7_Button.Value == 1
                    MI=obtainMI(app,app.T7_filtred);
                    myText=vertcat(myText ,{'T7' MI});
                end
                if app.C5_Button.Value == 1
                    MI=obtainMI(app,app.C5_filtred);
                    myText=vertcat(myText ,{'C5' MI});
                end
                if app.C3_Button.Value == 1
                    MI=obtainMI(app,app.C3_filtred);
                    myText=vertcat(myText ,{'C3' MI});
                end
                if app.C1_Button.Value == 1
                    MI=obtainMI(app,app.C1_filtred);
                    myText=vertcat(myText ,{'C1' MI});
                end
                if app.Cz_Button.Value == 1
                    MI=obtainMI(app,app.Cz_filtred);
                    myText=vertcat(myText ,{'Cz' MI});
                end
                if app.C2_Button.Value == 1
                    MI=obtainMI(app,app.C2_filtred);
                    myText=vertcat(myText ,{'C2' MI});
                end
                if app.C4_Button.Value == 1
                    MI=obtainMI(app,app.C4_filtred);
                    myText=vertcat(myText ,{'C4' MI});
                end
                if app.C6_Button.Value == 1
                    MI=obtainMI(app,app.C6_filtred);
                    myText=vertcat(myText ,{'C6' MI});
                end
                if app.T8_Button.Value == 1
                    MI=obtainMI(app,app.T8_filtred);
                    myText=vertcat(myText ,{'T8' MI});
                end
                if app.TP7_Button.Value == 1
                    MI=obtainMI(app,app.TP7_filtred);
                    myText=vertcat(myText ,{'TP7' MI});
                end
                if app.CP5_Button.Value == 1
                    MI=obtainMI(app,app.CP5_filtred);
                    myText=vertcat(myText ,{'CP5' MI});
                end
                if app.CP3_Button.Value == 1
                    MI=obtainMI(app,app.CP3_filtred);
                    myText=vertcat(myText ,{'CP3' MI});
                end
                if app.CP1_Button.Value == 1
                    MI=obtainMI(app,app.CP1_filtred);
                    myText=vertcat(myText ,{'CP1' MI});
                end
                if app.CPz_Button.Value == 1
                    MI=obtainMI(app,app.CPz_filtred);
                    myText=vertcat(myText ,{'CPz' MI});
                end
                
                if app.CP2_Button.Value == 1
                    MI=obtainMI(app,app.CP2_filtred);
                    myText=vertcat(myText ,{'CP2' MI});
                end
                if app.CP4_Button.Value == 1
                    MI=obtainMI(app,app.CP4_filtred);
                    myText=vertcat(myText ,{'CP4' MI});
                end
                if app.CP6_Button.Value == 1
                    MI=obtainMI(app,app.CP6_filtred);
                    myText=vertcat(myText ,{'CP6' MI});
                end
                if app.TP8_Button.Value == 1
                    MI=obtainMI(app,app.TP8_filtred);
                    myText=vertcat(myText ,{'TP8' MI});
                end
                if app.P7_Button.Value == 1
                    MI=obtainMI(app,app.P7_filtred);
                    myText=vertcat(myText ,{'P7' MI});
                end
                if app.P5_Button.Value == 1
                    MI=obtainMI(app,app.P5_filtred);
                    myText=vertcat(myText ,{'P5' MI});
                end
                if app.P3_Button.Value == 1
                    MI=obtainMI(app,app.P3_filtred);
                    myText=vertcat(myText ,{'P3' MI});
                end
                if app.P1_Button.Value == 1
                    MI=obtainMI(app,app.P1_filtred);
                    myText=vertcat(myText ,{'P1' MI});
                end
                if app.Pz_Button.Value == 1
                    MI=obtainMI(app,app.Pz_filtred);
                    myText=vertcat(myText ,{'Pz' MI});
                end
                if app.P2_Button.Value == 1
                    MI=obtainMI(app,app.P2_filtred);
                    myText=vertcat(myText ,{'P2' MI});
                end
                if app.P4_Button.Value == 1
                    MI=obtainMI(app,app.P4_filtred);
                    myText=vertcat(myText ,{'P4' MI});
                end
                if app.P6_Button.Value == 1
                    MI=obtainMI(app,app.P6_filtred);
                    myText=vertcat(myText ,{'P6' MI});
                end
                if app.P8_Button.Value == 1
                    MI=obtainMI(app,app.P8_filtred);
                    myText=vertcat(myText ,{'P8' MI});
                end
                if app.PO7_Button.Value == 1
                    MI=obtainMI(app,app.PO7_filtred);
                    myText=vertcat(myText ,{'PO7' MI});
                end
                if app.PO3_Button.Value == 1
                    MI=obtainMI(app,app.PO3_filtred);
                    myText=vertcat(myText ,{'PO3' MI});
                end
                if app.PO4_Button.Value == 1
                    MI=obtainMI(app,app.PO4_filtred);
                    myText=vertcat(myText ,{'PO4' MI});
                end
                if app.PO8_Button.Value == 1
                    MI=obtainMI(app,app.PO8_filtred);
                    myText=vertcat(myText ,{'PO8' MI});
                end
                if app.O1_Button.Value == 1
                    MI=obtainMI(app,app.O1_filtred);
                    myText=vertcat(myText ,{'O1' MI});
                end
                if app.Oz_Button.Value == 1
                    MI=obtainMI(app,app.Oz_filtred);
                    myText=vertcat(myText ,{'Oz' MI});
                end
                if app.O2_Button.Value == 1
                    MI=obtainMI(app,app.O2_filtred);
                    myText=vertcat(myText ,{'O2' MI});
                end
            end
            xlswrite(FileName,myText);
        end
        
        function results = obtainMI(app,input)
                [myaudio,app.Fs] = audioread(['audios/Stimuli/' app.AudioFile]);
                hist1=myproces(app,input);
                hist2=myproces(app,myaudio);
                [entropy1, prob1]=myentropy(app,hist1);
                [entropy2, prob2]=myentropy(app,hist2);
                MI=myMI(app,entropy1, entropy2, prob1,prob2);
                results=MI;
        end
        
        function results = typeIntotxt(app,fileID)
            fprintf(fileID,'These are the MI values for each selected channel:');
            fprintf(fileID,'\n');
            if app.filter==0
                if app.Fpz_Button.Value == 1
                    MI=obtainMI(app,app.Fpz);
                    fprintf(fileID,['Fpz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fp1_Button.Value == 1
                    MI=obtainMI(app,app.Fp1);
                    fprintf(fileID,['Fp1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fp2_Button.Value == 1
                    MI=obtainMI(app,app.Fp2);
                    fprintf(fileID,['Fp2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF7_Button.Value == 1
                    MI=obtainMI(app,app.AF7);
                    fprintf(fileID,['AF7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF3_Button.Value == 1
                    MI=obtainMI(app,app.AF3);
                    fprintf(fileID,['AF3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF4_Button.Value == 1
                    MI=obtainMI(app,app.AF4);
                    fprintf(fileID,['AF4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF8_Button.Value == 1
                    MI=obtainMI(app,app.AF8);
                    fprintf(fileID,['AF8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F7_Button.Value == 1
                    MI=obtainMI(app,app.F7);
                    fprintf(fileID,['F7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F5_Button.Value == 1
                    MI=obtainMI(app,app.F5);
                    fprintf(fileID,['F5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F3_Button.Value == 1
                    MI=obtainMI(app,app.F3);
                    fprintf(fileID,['F3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F1_Button.Value == 1
                    MI=obtainMI(app,app.F1);
                    fprintf(fileID,['F1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fz_Button.Value == 1
                    MI=obtainMI(app,app.Fz);
                    fprintf(fileID,['Fz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F2_Button.Value == 1
                    MI=obtainMI(app,app.F2);
                    fprintf(fileID,['F2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F4_Button.Value == 1
                    MI=obtainMI(app,app.F4);
                    fprintf(fileID,['F4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F6_Button.Value == 1
                    MI=obtainMI(app,app.F6);
                    fprintf(fileID,['F6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F8_Button.Value == 1
                    MI=obtainMI(app,app.F8);
                    fprintf(fileID,['F8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FT7_Button.Value == 1
                    MI=obtainMI(app,app.FT7);
                    fprintf(fileID,['FT7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC5_Button.Value == 1
                    MI=obtainMI(app,app.FC5);
                    fprintf(fileID,['FC5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC3_Button.Value == 1
                    MI=obtainMI(app,app.FC3);
                    fprintf(fileID,['FC3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC1_Button.Value == 1
                    MI=obtainMI(app,app.FC1);
                    fprintf(fileID,['FC1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FCz_Button.Value == 1
                    MI=obtainMI(app,app.FCz);
                    fprintf(fileID,['FCz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC2_Button.Value == 1
                    MI=obtainMI(app,app.FC2);
                    fprintf(fileID,['FC2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC4_Button.Value == 1
                    MI=obtainMI(app,app.FC4);
                    fprintf(fileID,['FC4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                
                if app.FC6_Button.Value == 1
                    MI=obtainMI(app,app.FC6);
                    fprintf(fileID,['FC6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FT8_Button.Value == 1
                    MI=obtainMI(app,app.FT8);
                    fprintf(fileID,['FT8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.T7_Button.Value == 1
                    MI=obtainMI(app,app.T7);
                    fprintf(fileID,['T7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C5_Button.Value == 1
                    MI=obtainMI(app,app.C5);
                    fprintf(fileID,['C5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C3_Button.Value == 1
                    MI=obtainMI(app,app.C3);
                    fprintf(fileID,['C3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C1_Button.Value == 1
                    MI=obtainMI(app,app.C1);
                    fprintf(fileID,['C1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Cz_Button.Value == 1
                    MI=obtainMI(app,app.Cz);
                    fprintf(fileID,['Cz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C2_Button.Value == 1
                    MI=obtainMI(app,app.C2);
                    fprintf(fileID,['C2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C4_Button.Value == 1
                    MI=obtainMI(app,app.C4);
                    fprintf(fileID,['C4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C6_Button.Value == 1
                    MI=obtainMI(app,app.C6);
                    fprintf(fileID,['C6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.T8_Button.Value == 1
                    MI=obtainMI(app,app.T8);
                    fprintf(fileID,['T8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.TP7_Button.Value == 1
                    MI=obtainMI(app,app.TP7);
                    fprintf(fileID,['TP7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP5_Button.Value == 1
                    MI=obtainMI(app,app.CP5);
                    fprintf(fileID,['CP5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP3_Button.Value == 1
                    MI=obtainMI(app,app.CP3);
                    fprintf(fileID,['CP3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP1_Button.Value == 1
                    MI=obtainMI(app,app.CP1);
                    fprintf(fileID,['CP1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CPz_Button.Value == 1
                    MI=obtainMI(app,app.CPz);
                    fprintf(fileID,['CPz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP2_Button.Value == 1
                    MI=obtainMI(app,app.CP2);
                    fprintf(fileID,['CP2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP4_Button.Value == 1
                    MI=obtainMI(app,app.CP4);
                    fprintf(fileID,['CP4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP6_Button.Value == 1
                    MI=obtainMI(app,app.CP6);
                    fprintf(fileID,['CP6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.TP8_Button.Value == 1
                    MI=obtainMI(app,app.TP8);
                    fprintf(fileID,['TP8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P7_Button.Value == 1
                    MI=obtainMI(app,app.P7);
                    fprintf(fileID,['P7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P5_Button.Value == 1
                    MI=obtainMI(app,app.P5);
                    fprintf(fileID,['P5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P3_Button.Value == 1
                    MI=obtainMI(app,app.P3);
                    fprintf(fileID,['P3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P1_Button.Value == 1
                    MI=obtainMI(app,app.P1);
                    fprintf(fileID,['P1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Pz_Button.Value == 1
                    MI=obtainMI(app,app.Pz);
                    fprintf(fileID,['Pz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P2_Button.Value == 1
                    MI=obtainMI(app,app.P2);
                    fprintf(fileID,['P2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P4_Button.Value == 1
                    MI=obtainMI(app,app.P4);
                    fprintf(fileID,['P4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P6_Button.Value == 1
                    MI=obtainMI(app,app.P6);
                    fprintf(fileID,['P6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P8_Button.Value == 1
                    MI=obtainMI(app,app.P8);
                    fprintf(fileID,['P8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO7_Button.Value == 1
                    MI=obtainMI(app,app.PO7);
                    fprintf(fileID,['PO7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO3_Button.Value == 1
                    MI=obtainMI(app,app.PO3);
                    fprintf(fileID,['PO3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO4_Button.Value == 1
                    MI=obtainMI(app,app.PO4);
                    fprintf(fileID,['PO4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO8_Button.Value == 1
                    MI=obtainMI(app,app.PO8);
                    fprintf(fileID,['PO8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.O1_Button.Value == 1
                    MI=obtainMI(app,app.O1);
                    fprintf(fileID,['O1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Oz_Button.Value == 1
                    MI=obtainMI(app,app.Oz);
                    fprintf(fileID,['Oz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.O2_Button.Value == 1
                    MI=obtainMI(app,app.O2);
                    fprintf(fileID,['O2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end

                %             if app.AFz_Button.Value == 1
                %                 plot(app.UIAxes2,app.AFz); hold(app.UIAxes2, 'on')
                %             end

                %             if app.FOz_Button.Value == 1
                %                 plot(app.UIAxes2,app.FOz); hold(app.UIAxes2, 'on')
                %             end
                
                %             if app.Iz_Button.Value == 1
                %                 plot(app.UIAxes2,app.Iz); hold(app.UIAxes2, 'on')
                %             end

            else
                if app.Fpz_Button.Value == 1
                    MI=obtainMI(app,app.Fpz_filtred);
                    fprintf(fileID,['Fpz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fp1_Button.Value == 1
                    MI=obtainMI(app,app.Fp1_filtred);
                    fprintf(fileID,['Fp1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fp2_Button.Value == 1
                    MI=obtainMI(app,app.Fp2_filtred);
                    fprintf(fileID,['Fp2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF7_Button.Value == 1
                    MI=obtainMI(app,app.AF7_filtred);
                    fprintf(fileID,['AF7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF3_Button.Value == 1
                    MI=obtainMI(app,app.AF3_filtred);
                    fprintf(fileID,['AF3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF4_Button.Value == 1
                    MI=obtainMI(app,app.AF4_filtred);
                    fprintf(fileID,['AF4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.AF8_Button.Value == 1
                    MI=obtainMI(app,app.AF8_filtred);
                    fprintf(fileID,['AF8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F7_Button.Value == 1
                    MI=obtainMI(app,app.F7_filtred);
                    fprintf(fileID,['F7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F5_Button.Value == 1
                    MI=obtainMI(app,app.F5_filtred);
                    fprintf(fileID,['F5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F3_Button.Value == 1
                    MI=obtainMI(app,app.F3_filtred);
                    fprintf(fileID,['F3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F1_Button.Value == 1
                    MI=obtainMI(app,app.F1_filtred);
                    fprintf(fileID,['F1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Fz_Button.Value == 1
                    MI=obtainMI(app,app.Fz_filtred);
                    fprintf(fileID,['Fz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F2_Button.Value == 1
                    MI=obtainMI(app,app.F2_filtred);
                    fprintf(fileID,['F2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F4_Button.Value == 1
                    MI=obtainMI(app,app.F4_filtred);
                    fprintf(fileID,['F4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F6_Button.Value == 1
                    MI=obtainMI(app,app.F6_filtred);
                    fprintf(fileID,['F6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.F8_Button.Value == 1
                    MI=obtainMI(app,app.F8_filtred);
                    fprintf(fileID,['F8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FT7_Button.Value == 1
                    MI=obtainMI(app,app.FT7_filtred);
                    fprintf(fileID,['FT7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC5_Button.Value == 1
                    MI=obtainMI(app,app.FC5_filtred);
                    fprintf(fileID,['FC5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC3_Button.Value == 1
                    MI=obtainMI(app,app.FC3_filtred);
                    fprintf(fileID,['FC3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC1_Button.Value == 1
                    MI=obtainMI(app,app.FC1_filtred);
                    fprintf(fileID,['FC1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FCz_Button.Value == 1
                    MI=obtainMI(app,app.FCz_filtred);
                    fprintf(fileID,['FCz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC2_Button.Value == 1
                    MI=obtainMI(app,app.FC2_filtred);
                    fprintf(fileID,['FC2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FC4_Button.Value == 1
                    MI=obtainMI(app,app.FC4_filtred);
                    fprintf(fileID,['FC4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                
                if app.FC6_Button.Value == 1
                    MI=obtainMI(app,app.FC6_filtred);
                    fprintf(fileID,['FC6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.FT8_Button.Value == 1
                    MI=obtainMI(app,app.FT8_filtred);
                    fprintf(fileID,['FT8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.T7_Button.Value == 1
                    MI=obtainMI(app,app.T7_filtred);
                    fprintf(fileID,['T7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C5_Button.Value == 1
                    MI=obtainMI(app,app.C5_filtred);
                    fprintf(fileID,['C5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C3_Button.Value == 1
                    MI=obtainMI(app,app.C3_filtred);
                    fprintf(fileID,['C3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C1_Button.Value == 1
                    MI=obtainMI(app,app.C1_filtred);
                    fprintf(fileID,['C1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Cz_Button.Value == 1
                    MI=obtainMI(app,app.Cz_filtred);
                    fprintf(fileID,['Cz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C2_Button.Value == 1
                    MI=obtainMI(app,app.C2_filtred);
                    fprintf(fileID,['C2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C4_Button.Value == 1
                    MI=obtainMI(app,app.C4_filtred);
                    fprintf(fileID,['C4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.C6_Button.Value == 1
                    MI=obtainMI(app,app.C6_filtred);
                    fprintf(fileID,['C6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.T8_Button.Value == 1
                    MI=obtainMI(app,app.T8_filtred);
                    fprintf(fileID,['T8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.TP7_Button.Value == 1
                    MI=obtainMI(app,app.TP7_filtred);
                    fprintf(fileID,['TP7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP5_Button.Value == 1
                    MI=obtainMI(app,app.CP5_filtred);
                    fprintf(fileID,['CP5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP3_Button.Value == 1
                    MI=obtainMI(app,app.CP3_filtred);
                    fprintf(fileID,['CP3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP1_Button.Value == 1
                    MI=obtainMI(app,app.CP1_filtred);
                    fprintf(fileID,['CP1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CPz_Button.Value == 1
                    MI=obtainMI(app,app.CPz_filtred);
                    fprintf(fileID,['CPz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP2_Button.Value == 1
                    MI=obtainMI(app,app.CP2_filtred);
                    fprintf(fileID,['CP2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP4_Button.Value == 1
                    MI=obtainMI(app,app.CP4_filtred);
                    fprintf(fileID,['CP4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.CP6_Button.Value == 1
                    MI=obtainMI(app,app.CP6_filtred);
                    fprintf(fileID,['CP6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.TP8_Button.Value == 1
                    MI=obtainMI(app,app.TP8_filtred);
                    fprintf(fileID,['TP8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P7_Button.Value == 1
                    MI=obtainMI(app,app.P7_filtred);
                    fprintf(fileID,['P7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P5_Button.Value == 1
                    MI=obtainMI(app,app.P5_filtred);
                    fprintf(fileID,['P5;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P3_Button.Value == 1
                    MI=obtainMI(app,app.P3_filtred);
                    fprintf(fileID,['P3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P1_Button.Value == 1
                    MI=obtainMI(app,app.P1_filtred);
                    fprintf(fileID,['P1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Pz_Button.Value == 1
                    MI=obtainMI(app,app.Pz_filtred);
                    fprintf(fileID,['Pz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P2_Button.Value == 1
                    MI=obtainMI(app,app.P2_filtred);
                    fprintf(fileID,['P2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P4_Button.Value == 1
                    MI=obtainMI(app,app.P4_filtred);
                    fprintf(fileID,['P4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P6_Button.Value == 1
                    MI=obtainMI(app,app.P6_filtred);
                    fprintf(fileID,['P6;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.P8_Button.Value == 1
                    MI=obtainMI(app,app.P8_filtred);
                    fprintf(fileID,['P8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO7_Button.Value == 1
                    MI=obtainMI(app,app.PO7_filtred);
                    fprintf(fileID,['PO7;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO3_Button.Value == 1
                    MI=obtainMI(app,app.PO3_filtred);
                    fprintf(fileID,['PO3;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO4_Button.Value == 1
                    MI=obtainMI(app,app.PO4_filtred);
                    fprintf(fileID,['PO4;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.PO8_Button.Value == 1
                    MI=obtainMI(app,app.PO8_filtred);
                    fprintf(fileID,['PO8;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.O1_Button.Value == 1
                    MI=obtainMI(app,app.O1_filtred);
                    fprintf(fileID,['O1;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.Oz_Button.Value == 1
                    MI=obtainMI(app,app.Oz_filtred);
                    fprintf(fileID,['Oz;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
                if app.O2_Button.Value == 1
                    MI=obtainMI(app,app.O2_filtred);
                    fprintf(fileID,['O2;' num2str(MI)]);
                    fprintf(fileID,'\n');
                end
            end
        end
        
        function results = typeIntoWord(app,selection)
            selection.TypeText(['Segment analyzed: '  app.segmentName]);
            selection.TypeParagraph;
            selection.TypeText(['Subject: ' app.subject]);
            selection.TypeParagraph;
            selection.TypeText('Face type: ');
            selection.TypeParagraph;
            if app.FaceCode(1)=='1'
                selection.TypeText('-Face');
            else
                selection.TypeText('-Scrambled');
            end
            selection.TypeParagraph;
            switch app.FaceCode(2)
                case '1'
                    selection.TypeText('-Woman 1');
                case '2'
                    selection.TypeText('-Woman 2');
                case '3'
                    selection.TypeText('-Man 1');
                case '4'
                    selection.TypeText('-Man 2');
            end
            selection.TypeParagraph;
            selection.TypeText('Audio type: ');
            selection.TypeParagraph;
            if length(app.AudioFile)== 12
                selection.TypeText('-Incorrect');
                selection.TypeParagraph;
                selection.TypeText('-Semantic error');
                selection.TypeParagraph;
            elseif app.AudioFile(7) == 'i'
                selection.TypeText('-Incorrect');
                selection.TypeParagraph;
                selection.TypeText('-Morphosyntactic error');
                selection.TypeParagraph;
            else
                selection.TypeText('-Correct');
                selection.TypeParagraph;
            end
            AStart=str2double(app.AudioStart);
            AStart=AStart/250;
            AEnd=str2double(app.AudioEnd);
            AEnd=AEnd/250;
            
            selection.TypeText(['-Audio file: ' app.AudioFile]);
            selection.TypeParagraph;
            selection.TypeText(['-Start time: ' num2str(AStart), ' s']);
            selection.TypeParagraph;
            selection.TypeText(['-End time: ' num2str(AEnd), ' s']);
            selection.TypeParagraph;
            if length(app.AudioFile)== 12 || app.AudioFile(7) == 'i'
                SStart=str2double(app.StimStart);
                SStart=SStart/250;
                selection.TypeText(['-Incorrection at: ' num2str(SStart), ' s']);
                selection.TypeParagraph;
            end
            selection.TypeText(['-Voice ', app.AudioCode(3)]);
            
            selection.TypeParagraph;
            calculateHigherMIs(app);
             app.higherMIs;
            selection.TypeText(['Electrodes with higher MI: ', app.higherMIs]);
            selection.TypeParagraph;
            
            if app.filter==1
                selection.TypeText(['Band analyzed: ', app.BandselectionDropDown_2.Value]);
                selection.TypeParagraph;
            end
            
            
            getPrintedNames(app);
            selection.TypeText(['Channels printed: ', app.myFileName]);
            selection.TypeParagraph;
                        
        end
        
        function results = calculateAllMIs(app)
            app.MIvector=[];
            if app.filter==0
                
                app.FpzMI=obtainMI(app,app.Fpz);
                app.MIvector=horzcat(app.MIvector,app.FpzMI);
                app.Fp1MI=obtainMI(app,app.Fp1);
                app.MIvector=horzcat(app.MIvector,app.Fp1MI);
                app.Fp2MI=obtainMI(app,app.Fp2);
                app.MIvector=horzcat(app.MIvector,app.Fp2MI);
                app.AF7MI=obtainMI(app,app.AF7);
                app.MIvector=horzcat(app.MIvector,app.AF7MI);
                app.AF3MI=obtainMI(app,app.AF3);
                app.MIvector=horzcat(app.MIvector,app.AF3MI);
                app.AF4MI=obtainMI(app,app.AF4);
                app.MIvector=horzcat(app.MIvector,app.AF4MI);
                
                app.AF8MI=obtainMI(app,app.AF8);
                app.MIvector=horzcat(app.MIvector,app.AF8MI);
                
                app.F7MI=obtainMI(app,app.F7);
                app.MIvector=horzcat(app.MIvector,app.F7MI);
                
                app.F5MI=obtainMI(app,app.F5);
                app.MIvector=horzcat(app.MIvector,app.F5MI);
                
                app.F3MI=obtainMI(app,app.F3);
                app.MIvector=horzcat(app.MIvector,app.F3MI);
                
                app.F1MI=obtainMI(app,app.F1);
                app.MIvector=horzcat(app.MIvector,app.F1MI);
                
                app.FzMI=obtainMI(app,app.Fz);
                app.MIvector=horzcat(app.MIvector,app.FzMI);
                
                app.F2MI=obtainMI(app,app.F2);
                app.MIvector=horzcat(app.MIvector,app.F2MI);
                
                app.F4MI=obtainMI(app,app.F4);
                app.MIvector=horzcat(app.MIvector,app.F4MI);
                
                app.F6MI=obtainMI(app,app.F6);
                app.MIvector=horzcat(app.MIvector,app.F6MI);
                
                app.F8MI=obtainMI(app,app.F8);
                app.MIvector=horzcat(app.MIvector,app.F8MI);
                
                app.FT7MI=obtainMI(app,app.FT7);
                app.MIvector=horzcat(app.MIvector,app.FT7MI);
                
                app.FC5MI=obtainMI(app,app.FC5);
                app.MIvector=horzcat(app.MIvector,app.FC5MI);
                
                app.FC3MI=obtainMI(app,app.FC3);
                app.MIvector=horzcat(app.MIvector,app.FC3MI);
                
                app.FC1MI=obtainMI(app,app.FC1);
                app.MIvector=horzcat(app.MIvector,app.FC1MI);
                
                app.FCzMI=obtainMI(app,app.FCz);
                app.MIvector=horzcat(app.MIvector,app.FCzMI);
                
                app.FC2MI=obtainMI(app,app.FC2);
                app.MIvector=horzcat(app.MIvector,app.FC2MI);
                
                app.FC4MI=obtainMI(app,app.FC4);
                app.MIvector=horzcat(app.MIvector,app.FC4MI);
                
                app.FC6MI=obtainMI(app,app.FC6);
                app.MIvector=horzcat(app.MIvector,app.FC6MI);
                
                app.FT8MI=obtainMI(app,app.FT8);
                app.MIvector=horzcat(app.MIvector,app.FT8MI);
                
                app.T7MI=obtainMI(app,app.T7);
                app.MIvector=horzcat(app.MIvector,app.T7MI);
                
                app.C5MI=obtainMI(app,app.C5);
                app.MIvector=horzcat(app.MIvector,app.C5MI);
                
                app.C3MI=obtainMI(app,app.C3);
                app.MIvector=horzcat(app.MIvector,app.C3MI);
                
                app.C1MI=obtainMI(app,app.C1);
                app.MIvector=horzcat(app.MIvector,app.C1MI);
                
                
                app.CzMI=obtainMI(app,app.Cz);
                app.MIvector=horzcat(app.MIvector,app.CzMI);
                
                app.C2MI=obtainMI(app,app.C2);
                app.MIvector=horzcat(app.MIvector,app.C2MI);
                
                app.C4MI=obtainMI(app,app.C4);
                app.MIvector=horzcat(app.MIvector,app.C4MI);
                
                app.C6MI=obtainMI(app,app.C6);
                app.MIvector=horzcat(app.MIvector,app.C6MI);
                
                app.T8MI=obtainMI(app,app.T8);
                app.MIvector=horzcat(app.MIvector,app.T8MI);
                
                app.TP7MI=obtainMI(app,app.TP7);
                app.MIvector=horzcat(app.MIvector,app.TP7MI);
                
                app.CP5MI=obtainMI(app,app.CP5);
                app.MIvector=horzcat(app.MIvector,app.CP5MI);
                
                app.CP3MI=obtainMI(app,app.CP3);
                app.MIvector=horzcat(app.MIvector,app.CP3MI);
                
                app.CP1MI=obtainMI(app,app.CP1);
                app.MIvector=horzcat(app.MIvector,app.CP1MI);
                
                app.CPzMI=obtainMI(app,app.CPz);
                app.MIvector=horzcat(app.MIvector,app.CPzMI);
                
                app.CP2MI=obtainMI(app,app.CP2);
                app.MIvector=horzcat(app.MIvector,app.CP2MI);
                
                app.CP4MI=obtainMI(app,app.CP4);
                app.MIvector=horzcat(app.MIvector,app.CP4MI);
                
                app.CP6MI=obtainMI(app,app.CP6);
                app.MIvector=horzcat(app.MIvector,app.CP6MI);
                
                app.TP8MI=obtainMI(app,app.TP8);
                app.MIvector=horzcat(app.MIvector,app.TP8MI);
                
                app.P7MI=obtainMI(app,app.P7);
                app.MIvector=horzcat(app.MIvector,app.P7MI);
                
                app.P5MI=obtainMI(app,app.P5);
                app.MIvector=horzcat(app.MIvector,app.P5MI);
                
                app.P3MI=obtainMI(app,app.P3);
                app.MIvector=horzcat(app.MIvector,app.P3MI);
                
                app.P1MI=obtainMI(app,app.P1);
                app.MIvector=horzcat(app.MIvector,app.P1MI);
                
                app.PzMI=obtainMI(app,app.Pz);
                app.MIvector=horzcat(app.MIvector,app.PzMI);
                
                app.P2MI=obtainMI(app,app.P2);
                app.MIvector=horzcat(app.MIvector,app.P2MI);
                
                app.P4MI=obtainMI(app,app.P4);
                app.MIvector=horzcat(app.MIvector,app.P4MI);
                
                app.P6MI=obtainMI(app,app.P6);
                app.MIvector=horzcat(app.MIvector,app.P6MI);
                
                app.P8MI=obtainMI(app,app.P8);
                app.MIvector=horzcat(app.MIvector,app.P8MI);
                
                app.PO7MI=obtainMI(app,app.PO7);
                app.MIvector=horzcat(app.MIvector,app.PO7MI);
                
                app.PO3MI=obtainMI(app,app.PO3);
                app.MIvector=horzcat(app.MIvector,app.PO3MI);
                
                app.PO4MI=obtainMI(app,app.PO4);
                app.MIvector=horzcat(app.MIvector,app.PO4MI);
                
                app.PO8MI=obtainMI(app,app.PO8);
                app.MIvector=horzcat(app.MIvector,app.PO8MI);
                
                app.O1MI=obtainMI(app,app.O1);
                app.MIvector=horzcat(app.MIvector,app.O1MI);
                
                app.OzMI=obtainMI(app,app.Oz);
                app.MIvector=horzcat(app.MIvector,app.OzMI);
                
                app.O2MI=obtainMI(app,app.O2);
                app.MIvector=horzcat(app.MIvector,app.O2MI);
                
            else
                
                app.FpzMI=obtainMI(app,app.Fpz_filtred);
                app.MIvector=horzcat(app.MIvector,app.FpzMI);
                app.Fp1MI=obtainMI(app,app.Fp1_filtred);
                app.MIvector=horzcat(app.MIvector,app.Fp1MI);
                app.Fp2MI=obtainMI(app,app.Fp2_filtred);
                app.MIvector=horzcat(app.MIvector,app.Fp2MI);
                app.AF7MI=obtainMI(app,app.AF7_filtred);
                app.MIvector=horzcat(app.MIvector,app.AF7MI);
                app.AF3MI=obtainMI(app,app.AF3_filtred);
                app.MIvector=horzcat(app.MIvector,app.AF3MI);
                app.AF4MI=obtainMI(app,app.AF4_filtred);
                app.MIvector=horzcat(app.MIvector,app.AF4MI);
                
                app.AF8MI=obtainMI(app,app.AF8_filtred);
                app.MIvector=horzcat(app.MIvector,app.AF8MI);
                
                app.F7MI=obtainMI(app,app.F7_filtred);
                app.MIvector=horzcat(app.MIvector,app.F7MI);
                
                app.F5MI=obtainMI(app,app.F5_filtred);
                app.MIvector=horzcat(app.MIvector,app.F5MI);
                
                app.F3MI=obtainMI(app,app.F3_filtred);
                app.MIvector=horzcat(app.MIvector,app.F3MI);
                
                app.F1MI=obtainMI(app,app.F1_filtred);
                app.MIvector=horzcat(app.MIvector,app.F1MI);
                
                app.FzMI=obtainMI(app,app.Fz_filtred);
                app.MIvector=horzcat(app.MIvector,app.FzMI);
                
                app.F2MI=obtainMI(app,app.F2_filtred);
                app.MIvector=horzcat(app.MIvector,app.F2MI);
                
                app.F4MI=obtainMI(app,app.F4_filtred);
                app.MIvector=horzcat(app.MIvector,app.F4MI);
                
                app.F6MI=obtainMI(app,app.F6_filtred);
                app.MIvector=horzcat(app.MIvector,app.F6MI);
                
                app.F8MI=obtainMI(app,app.F8_filtred);
                app.MIvector=horzcat(app.MIvector,app.F8MI);
                
                app.FT7MI=obtainMI(app,app.FT7_filtred);
                app.MIvector=horzcat(app.MIvector,app.FT7MI);
                
                app.FC5MI=obtainMI(app,app.FC5_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC5MI);
                
                app.FC3MI=obtainMI(app,app.FC3_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC3MI);
                
                app.FC1MI=obtainMI(app,app.FC1_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC1MI);
                
                app.FCzMI=obtainMI(app,app.FCz_filtred);
                app.MIvector=horzcat(app.MIvector,app.FCzMI);
                
                app.FC2MI=obtainMI(app,app.FC2_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC2MI);
                
                app.FC4MI=obtainMI(app,app.FC4_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC4MI);
                
                app.FC6MI=obtainMI(app,app.FC6_filtred);
                app.MIvector=horzcat(app.MIvector,app.FC6MI);
                
                app.FT8MI=obtainMI(app,app.FT8_filtred);
                app.MIvector=horzcat(app.MIvector,app.FT8MI);
                
                app.T7MI=obtainMI(app,app.T7_filtred);
                app.MIvector=horzcat(app.MIvector,app.T7MI);
                
                app.C5MI=obtainMI(app,app.C5_filtred);
                app.MIvector=horzcat(app.MIvector,app.C5MI);
                
                app.C3MI=obtainMI(app,app.C3_filtred);
                app.MIvector=horzcat(app.MIvector,app.C3MI);
                
                app.C1MI=obtainMI(app,app.C1_filtred);
                app.MIvector=horzcat(app.MIvector,app.C1MI);
                
                
                app.CzMI=obtainMI(app,app.Cz_filtred);
                app.MIvector=horzcat(app.MIvector,app.CzMI);
                
                app.C2MI=obtainMI(app,app.C2_filtred);
                app.MIvector=horzcat(app.MIvector,app.C2MI);
                
                app.C4MI=obtainMI(app,app.C4_filtred);
                app.MIvector=horzcat(app.MIvector,app.C4MI);
                
                app.C6MI=obtainMI(app,app.C6_filtred);
                app.MIvector=horzcat(app.MIvector,app.C6MI);
                
                app.T8MI=obtainMI(app,app.T8_filtred);
                app.MIvector=horzcat(app.MIvector,app.T8MI);
                
                app.TP7MI=obtainMI(app,app.TP7_filtred);
                app.MIvector=horzcat(app.MIvector,app.TP7MI);
                
                app.CP5MI=obtainMI(app,app.CP5_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP5MI);
                
                app.CP3MI=obtainMI(app,app.CP3_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP3MI);
                
                app.CP1MI=obtainMI(app,app.CP1_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP1MI);
                
                app.CPzMI=obtainMI(app,app.CPz_filtred);
                app.MIvector=horzcat(app.MIvector,app.CPzMI);
                
                app.CP2MI=obtainMI(app,app.CP2_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP2MI);
                
                app.CP4MI=obtainMI(app,app.CP4_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP4MI);
                
                app.CP6MI=obtainMI(app,app.CP6_filtred);
                app.MIvector=horzcat(app.MIvector,app.CP6MI);
                
                app.TP8MI=obtainMI(app,app.TP8_filtred);
                app.MIvector=horzcat(app.MIvector,app.TP8MI);
                
                app.P7MI=obtainMI(app,app.P7_filtred);
                app.MIvector=horzcat(app.MIvector,app.P7MI);
                
                app.P5MI=obtainMI(app,app.P5_filtred);
                app.MIvector=horzcat(app.MIvector,app.P5MI);
                
                app.P3MI=obtainMI(app,app.P3_filtred);
                app.MIvector=horzcat(app.MIvector,app.P3MI);
                
                app.P1MI=obtainMI(app,app.P1_filtred);
                app.MIvector=horzcat(app.MIvector,app.P1MI);
                
                app.PzMI=obtainMI(app,app.Pz_filtred);
                app.MIvector=horzcat(app.MIvector,app.PzMI);
                
                app.P2MI=obtainMI(app,app.P2_filtred);
                app.MIvector=horzcat(app.MIvector,app.P2MI);
                
                app.P4MI=obtainMI(app,app.P4_filtred);
                app.MIvector=horzcat(app.MIvector,app.P4MI);
                
                app.P6MI=obtainMI(app,app.P6_filtred);
                app.MIvector=horzcat(app.MIvector,app.P6MI);
                
                app.P8MI=obtainMI(app,app.P8_filtred);
                app.MIvector=horzcat(app.MIvector,app.P8MI);
                
                app.PO7MI=obtainMI(app,app.PO7_filtred);
                app.MIvector=horzcat(app.MIvector,app.PO7MI);
                
                app.PO3MI=obtainMI(app,app.PO3_filtred);
                app.MIvector=horzcat(app.MIvector,app.PO3MI);
                
                app.PO4MI=obtainMI(app,app.PO4_filtred);
                app.MIvector=horzcat(app.MIvector,app.PO4MI);
                
                app.PO8MI=obtainMI(app,app.PO8_filtred);
                app.MIvector=horzcat(app.MIvector,app.PO8MI);
                
                app.O1MI=obtainMI(app,app.O1_filtred);
                app.MIvector=horzcat(app.MIvector,app.O1MI);
                
                app.OzMI=obtainMI(app,app.Oz_filtred);
                app.MIvector=horzcat(app.MIvector,app.OzMI);
                
                app.O2MI=obtainMI(app,app.O2_filtred);
                app.MIvector=horzcat(app.MIvector,app.O2MI);
            end
            %             app.TotalMI=sum(app.FpzMI,app.Fp1MI,app.Fp2MI,app.AF7MI,app.AF3MI,app.AF4MI,app.AF8MI,app.F7MI,app.F5MI,app.F3MI,app.F1MI,app.FzMI,app.F2MI,app.F4MI,app.F6MI,app.F8MI,app.FT7MI,app.FC5MI,app.FC3MI,app.FC1MI,app.FCzMI,app.FC2MI,app.FC4MI,app.FC6MI,app.FT8MI,app.T7MI,app.C5MI,app.C3MI,app.C1MI,app.CzMI,app.C2MI,app.C4MI,app.C6MI,app.T8MI,app.TP7MI,app.CP5MI,app.CP3MI,app.CP1MI,app.CPzMI,app.CP2MI,app.CP4MI,app.CP6MI,app.TP8MI,app.P7MI,app.P5MI,app.P3MI,app.P1MI,app.PzMI,app.P2MI,app.P4MI,app.P6MI,app.P8MI,app.PO7MI,app.PO3MI,app.PO4MI,app.PO8MI,app.O1MI,app.OzMI,app.O2MI)
        end
 
        
        function results = printROIs(app)
            MImin=min(app.MIvector);
            MImax=max(app.MIvector);
            dif=[MImax-MImin];
            
            if MImax-app.Fp1MI<0.15*dif
                app.Fp1_Button.BackgroundColor='c';
            end
            if MImax-app.FpzMI<0.15*dif
                app.Fpz_Button.BackgroundColor='c';
            end
            if MImax-app.AF7MI<0.15*dif
                app.AF7_Button.BackgroundColor='c';
            end
            if MImax-app.AF3MI<0.15*dif
                app.AF3_Button.BackgroundColor='c';
            end
            if MImax-app.AF4MI<0.15*dif
                app.AF4_Button.BackgroundColor='c';
            end
            if MImax-app.AF8MI<0.15*dif
                app.AF8_Button.BackgroundColor='c';
            end
            if MImax-app.F7MI<0.15*dif
                app.F7_Button.BackgroundColor='c';
            end
            if MImax-app.F5MI<0.15*dif
                app.F5_Button.BackgroundColor='c';
            end
            if MImax-app.F3MI<0.15*dif
                app.F3_Button.BackgroundColor='c';
            end
            if MImax-app.F1MI<0.15*dif
                app.F1_Button.BackgroundColor='c';
            end
            
            if MImax-app.FzMI<0.15*dif
                app.Fz_Button.BackgroundColor='c';
            end
            if MImax-app.F2MI<0.15*dif
                app.F2_Button.BackgroundColor='c';
            end
            if MImax-app.F4MI<0.15*dif
                app.F4_Button.BackgroundColor='c';
            end
            if MImax-app.F6MI<0.15*dif
                app.F6_Button.BackgroundColor='c';
            end
            if MImax-app.F8MI<0.15*dif
                app.F8_Button.BackgroundColor='c';
            end
            if MImax-app.Fp2MI<0.15*dif
                app.Fp2_Button.BackgroundColor='c';
            end
            if MImax-app.FT7MI<0.15*dif
                app.FT7_Button.BackgroundColor='c';
            end
            if MImax-app.FC5MI<0.15*dif
                app.FC5_Button.BackgroundColor='c';
            end
            if MImax-app.FC3MI<0.15*dif
                app.FC3_Button.BackgroundColor='c';
            end
            if MImax-app.FC1MI<0.15*dif
                app.FC1_Button.BackgroundColor='c';
            end
            if MImax-app.FCzMI<0.15*dif
                app.FCz_Button.BackgroundColor='c';
            end
            
            if MImax-app.FC2MI<0.15*dif
                app.FC2_Button.BackgroundColor='c';
            end
            if MImax-app.FC4MI<0.15*dif
                app.FC4_Button.BackgroundColor='c';
            end
            if MImax-app.FC6MI<0.15*dif
                app.FC6_Button.BackgroundColor='c';
            end
            if MImax-app.FT8MI<0.15*dif
                app.FT8_Button.BackgroundColor='c';
            end
            if MImax-app.T7MI<0.15*dif
                app.T7_Button.BackgroundColor='c';
            end
            if MImax-app.C5MI<0.15*dif
                app.C5_Button.BackgroundColor='c';
            end
            if MImax-app.C3MI<0.15*dif
                app.C3_Button.BackgroundColor='c';
            end
            if MImax-app.C1MI<0.15*dif
                app.C1_Button.BackgroundColor='c';
            end
            if MImax-app.CzMI<0.15*dif
                app.Cz_Button.BackgroundColor='c';
            end
            if MImax-app.C2MI<0.15*dif
                app.C2_Button.BackgroundColor='c';
            end
            if MImax-app.C4MI<0.15*dif
                app.C4_Button.BackgroundColor='c';
            end
            
            if MImax-app.C6MI<0.15*dif
                app.C6_Button.BackgroundColor='c';
            end
            if MImax-app.T8MI<0.15*dif
                app.T8_Button.BackgroundColor='c';
            end
            if MImax-app.TP7MI<0.15*dif
                app.TP7_Button.BackgroundColor='c';
            end
            if MImax-app.CP5MI<0.15*dif
                app.CP5_Button.BackgroundColor='c';
            end
            if MImax-app.CP3MI<0.15*dif
                app.CP3_Button.BackgroundColor='c';
            end
            if MImax-app.CP1MI<0.15*dif
                app.CP1_Button.BackgroundColor='c';
            end
            if MImax-app.CPzMI<0.15*dif
                app.CPz_Button.BackgroundColor='c';
            end
            if MImax-app.CP2MI<0.15*dif
                app.CP2_Button.BackgroundColor='c';
            end
            if MImax-app.CP4MI<0.15*dif
                app.CP4_Button.BackgroundColor='c';
            end
            if MImax-app.CP6MI<0.15*dif
                app.CP6_Button.BackgroundColor='c';
            end
            if MImax-app.TP8MI<0.15*dif
                app.TP8_Button.BackgroundColor='c';
            end
            if MImax-app.P7MI<0.15*dif
                app.P7_Button.BackgroundColor='c';
            end
            if MImax-app.P5MI<0.15*dif
                app.P5_Button.BackgroundColor='c';
            end
            if MImax-app.P3MI<0.15*dif
                app.P3_Button.BackgroundColor='c';
            end
            if MImax-app.P1MI<0.15*dif
                app.P1_Button.BackgroundColor='c';
            end
            if MImax-app.PzMI<0.15*dif
                app.Pz_Button.BackgroundColor='c';
            end
            if MImax-app.P2MI<0.15*dif
                app.P2_Button.BackgroundColor='c';
            end
            if MImax-app.P4MI<0.15*dif
                app.P4_Button.BackgroundColor='c';
            end
            if MImax-app.P6MI<0.15*dif
                app.P6_Button.BackgroundColor='c';
            end
            if MImax-app.P8MI<0.15*dif
                app.P8_Button.BackgroundColor='c';
            end
            if MImax-app.PO7MI<0.15*dif
                app.PO7_Button.BackgroundColor='c';
            end
            if MImax-app.PO3MI<0.15*dif
                app.PO3_Button.BackgroundColor='c';
            end
            if MImax-app.PO4MI<0.15*dif
                app.PO4_Button.BackgroundColor='c';
            end
            if MImax-app.PO8MI<0.15*dif
                app.PO8_Button.BackgroundColor='c';
            end
            if MImax-app.O1MI<0.15*dif
                app.O1_Button.BackgroundColor='c';
            end
            if MImax-app.OzMI<0.15*dif
                app.Oz_Button.BackgroundColor='c';
            end
            if MImax-app.O2MI<0.15*dif
                app.O2_Button.BackgroundColor='c';
            end
            
        end
        
        function results = unprint(app)

                app.Fp1_Button.BackgroundColor=[0.94 0.94 0.94];
                app.Fpz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.AF7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.AF3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.AF4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.AF8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F5_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F1_Button.BackgroundColor=[0.94 0.94 0.94];

                app.Fz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F6_Button.BackgroundColor=[0.94 0.94 0.94];

                app.F8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.Fp2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FT7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC5_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC1_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FCz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FC6_Button.BackgroundColor=[0.94 0.94 0.94];

                app.FT8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.T7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C5_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C1_Button.BackgroundColor=[0.94 0.94 0.94];

                app.Cz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.C6_Button.BackgroundColor=[0.94 0.94 0.94];

                app.T8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.TP7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP5_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP1_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CPz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.CP6_Button.BackgroundColor=[0.94 0.94 0.94];

                app.TP8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P5_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P3_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P1_Button.BackgroundColor=[0.94 0.94 0.94];

                app.Pz_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P2_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P4_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P6_Button.BackgroundColor=[0.94 0.94 0.94];

                app.P8_Button.BackgroundColor=[0.94 0.94 0.94];

                app.PO7_Button.BackgroundColor=[0.94 0.94 0.94];

                app.PO3_Button.BackgroundColor=[0.94 0.94 0.94];
                
                app.PO4_Button.BackgroundColor=[0.94 0.94 0.94];
                
                app.PO8_Button.BackgroundColor=[0.94 0.94 0.94];
                
                app.O1_Button.BackgroundColor=[0.94 0.94 0.94];
                
                app.Oz_Button.BackgroundColor=[0.94 0.94 0.94];
                
                app.O2_Button.BackgroundColor=[0.94 0.94 0.94];
                
        end
        
        function results = getname(app)
            contador=0;
            app.myFileName=[];
            if app.Fpz_Button.Value == 1
                app.myFileName='Fpz-';
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.Fp1_Button.Value == 1
                app.myFileName=[app.myFileName 'Fp1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.Fp2_Button.Value == 1
                app.myFileName=[app.myFileName 'Fp2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.AF7_Button.Value == 1
                app.myFileName=[app.myFileName 'AF7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.AF3_Button.Value == 1
                app.myFileName=[app.myFileName 'AF3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.AF4_Button.Value == 1
                app.myFileName=[app.myFileName 'AF4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.AF8_Button.Value == 1
                app.myFileName=[app.myFileName 'AF8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F7_Button.Value == 1
                app.myFileName=[app.myFileName 'F7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F5_Button.Value == 1
                app.myFileName=[app.myFileName 'F5-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F3_Button.Value == 1
                app.myFileName=[app.myFileName 'F3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            
            if app.F1_Button.Value == 1
                app.myFileName=[app.myFileName 'F1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.Fz_Button.Value == 1
                app.myFileName=[app.myFileName 'Fz-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F2_Button.Value == 1
                app.myFileName=[app.myFileName 'F2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F4_Button.Value == 1
                app.myFileName=[app.myFileName 'F4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F6_Button.Value == 1
                app.myFileName=[app.myFileName 'F6-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.F8_Button.Value == 1
                app.myFileName=[app.myFileName 'F8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FT7_Button.Value == 1
                app.myFileName=[app.myFileName 'FT7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FC5_Button.Value == 1
                app.myFileName=[app.myFileName 'FC5-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            
            if app.FC3_Button.Value == 1
                app.myFileName=[app.myFileName 'FC3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FC1_Button.Value == 1
                app.myFileName=[app.myFileName 'FC1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FCz_Button.Value == 1
                app.myFileName=[app.myFileName 'FCz-'];
                contador=contador+1;
                if contador ==5
                    return
                    app.myFileName=[app.myFileName 'and more-'];
                end
            end
            
            if app.FC2_Button.Value == 1
                app.myFileName=[app.myFileName 'FC2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FC4_Button.Value == 1
                app.myFileName=[app.myFileName 'FC4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FC6_Button.Value == 1
                app.myFileName=[app.myFileName 'FC6-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.FT8_Button.Value == 1
                app.myFileName=[app.myFileName 'FT8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.T7_Button.Value == 1
                app.myFileName=[app.myFileName 'T7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C5_Button.Value == 1
                app.myFileName=[app.myFileName 'C5-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C3_Button.Value == 1
                app.myFileName=[app.myFileName 'C3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C1_Button.Value == 1
                app.myFileName=[app.myFileName 'C1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end      
            if app.Cz_Button.Value == 1
                app.myFileName=[app.myFileName 'Cz-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C2_Button.Value == 1
                app.myFileName=[app.myFileName 'C2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C4_Button.Value == 1
                app.myFileName=[app.myFileName 'C4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.C6_Button.Value == 1
                app.myFileName=[app.myFileName 'C6-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.T8_Button.Value == 1
                app.myFileName=[app.myFileName 'T8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.TP7_Button.Value == 1
                app.myFileName=[app.myFileName 'TP7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CP5_Button.Value == 1
                app.myFileName=[app.myFileName 'CP5-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CP3_Button.Value == 1
                app.myFileName=[app.myFileName 'CP3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CP1_Button.Value == 1
                app.myFileName=[app.myFileName 'CP1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CPz_Button.Value == 1
                app.myFileName=[app.myFileName 'CPz-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            
            if app.CP2_Button.Value == 1
                app.myFileName=[app.myFileName 'CP2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CP4_Button.Value == 1
                app.myFileName=[app.myFileName 'CP4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.CP6_Button.Value == 1
                app.myFileName=[app.myFileName 'CP6-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.TP8_Button.Value == 1
                app.myFileName=[app.myFileName 'TP8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P7_Button.Value == 1
                app.myFileName=[app.myFileName 'P7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P5_Button.Value == 1
                app.myFileName=[app.myFileName 'P5-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P3_Button.Value == 1
                app.myFileName=[app.myFileName 'P3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
                
            end            
            if app.P1_Button.Value == 1
                app.myFileName=[app.myFileName 'P1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.Pz_Button.Value == 1
                app.myFileName=[app.myFileName 'Pz-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P2_Button.Value == 1
                app.myFileName=[app.myFileName 'P2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P4_Button.Value == 1
                app.myFileName=[app.myFileName 'P4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P6_Button.Value == 1
                app.myFileName=[app.myFileName 'P6-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.P8_Button.Value == 1
                app.myFileName=[app.myFileName 'P8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.PO7_Button.Value == 1
                app.myFileName=[app.myFileName 'PO7-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.PO3_Button.Value == 1
                app.myFileName=[app.myFileName 'PO3-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.PO4_Button.Value == 1
                app.myFileName=[app.myFileName 'PO4-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.PO8_Button.Value == 1
                app.myFileName=[app.myFileName 'PO8-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.O1_Button.Value == 1
                app.myFileName=[app.myFileName 'O1-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.Oz_Button.Value == 1
                app.myFileName=[app.myFileName 'Oz-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
            if app.O2_Button.Value == 1
                app.myFileName=[app.myFileName 'O2-'];
                contador=contador+1;
                if contador ==5
                    app.myFileName=[app.myFileName 'and more-'];
                    return
                end
            end
        end
        
        function results = calculateHigherMIs(app)
            calculateAllMIs(app);
            MImin=min(app.MIvector);
            MImax=max(app.MIvector);
            dif=[MImax-MImin];
            app.higherMIs=[];
            if MImax-app.Fp1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'Fp1,-'];
            end
            if MImax-app.FpzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'Fpz,'];
            end
            if MImax-app.AF7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'AF7,'];
            end
            if MImax-app.AF3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'AF3,'];
            end
            if MImax-app.AF4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'AF4,'];
            end
            if MImax-app.AF8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'AF8,'];
            end
            if MImax-app.F7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F7,'];
            end
            if MImax-app.F5MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F5,'];
            end
            if MImax-app.F3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F3,'];
            end
            if MImax-app.F1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F1,'];
            end
            
            if MImax-app.FzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'Fz,'];
            end
            if MImax-app.F2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F2,'];
            end
            if MImax-app.F4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F4,'];
            end
            if MImax-app.F6MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F6,'];
            end
            if MImax-app.F8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'F8,'];
            end
            if MImax-app.Fp2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'Fp2,'];
            end
            if MImax-app.FT7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FT7,'];
            end
            if MImax-app.FC5MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC5,'];
            end
            if MImax-app.FC3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC3,'];
            end
            if MImax-app.FC1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC1,'];
            end
            if MImax-app.FCzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'FCz,'];
            end
            
            if MImax-app.FC2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC2,'];
            end
            if MImax-app.FC4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC4,'];
            end
            if MImax-app.FC6MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FC6,'];
            end
            if MImax-app.FT8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'FT8,'];
            end
            if MImax-app.T7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'T7,'];
            end
            if MImax-app.C5MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C5,'];
            end
            if MImax-app.C3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C3,'];
            end
            if MImax-app.C1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C1,'];
            end
            if MImax-app.CzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'Cz,'];
            end
            if MImax-app.C2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C2,'];
            end
            if MImax-app.C4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C4,'];
            end
            
            if MImax-app.C6MI<0.15*dif
                app.higherMIs=[app.higherMIs 'C6,'];
            end
            if MImax-app.T8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'T8,'];
            end
            if MImax-app.TP7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'TP7,'];
            end
            if MImax-app.CP5MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP5,'];
            end
            if MImax-app.CP3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP3,'];
            end
            if MImax-app.CP1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP1,'];
            end
            if MImax-app.CPzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'CPz,'];
            end
            if MImax-app.CP2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP2,'];
            end
            if MImax-app.CP4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP4,'];
            end
            if MImax-app.CP6MI<0.15*dif
                app.higherMIs=[app.higherMIs 'CP6,'];
            end
            if MImax-app.TP8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'TP8,'];
            end
            if MImax-app.P7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P7,'];
            end
            if MImax-app.P5MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P5,'];
            end
            if MImax-app.P3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P3,'];
            end
            if MImax-app.P1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P1,'];
            end
            if MImax-app.PzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'Pz,'];
            end
            if MImax-app.P2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P2,'];
            end
            if MImax-app.P4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P4,'];
            end
            if MImax-app.P6MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P6,'];
            end
            if MImax-app.P8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'P8,'];
            end
            if MImax-app.PO7MI<0.15*dif
                app.higherMIs=[app.higherMIs 'PO7,'];
            end
            if MImax-app.PO3MI<0.15*dif
                app.higherMIs=[app.higherMIs 'PO3,'];
            end
            if MImax-app.PO4MI<0.15*dif
                app.higherMIs=[app.higherMIs 'PO4,'];
            end
            if MImax-app.PO8MI<0.15*dif
                app.higherMIs=[app.higherMIs 'PO8,'];
            end
            if MImax-app.O1MI<0.15*dif
                app.higherMIs=[app.higherMIs 'O1,'];
            end
            if MImax-app.OzMI<0.15*dif
                app.higherMIs=[app.higherMIs 'Oz,'];
            end
            if MImax-app.O2MI<0.15*dif
                app.higherMIs=[app.higherMIs 'O2,'];
            end
        end
        
        function results = getPrintedNames(app)
            app.myFileName=[];
            if app.Fpz_Button.Value == 1
                app.myFileName='Fpz';

            end
            if app.Fp1_Button.Value == 1
                app.myFileName=[app.myFileName 'Fp1'];

            end
            if app.Fp2_Button.Value == 1
                app.myFileName=[app.myFileName '-Fp2'];

            end
            if app.AF7_Button.Value == 1
                app.myFileName=[app.myFileName '-AF7'];

            end
            if app.AF3_Button.Value == 1
                app.myFileName=[app.myFileName '-AF3'];

            end
            if app.AF4_Button.Value == 1
                app.myFileName=[app.myFileName '-AF4'];

            end
            if app.AF8_Button.Value == 1
                app.myFileName=[app.myFileName '-AF8'];

            end
            if app.F7_Button.Value == 1
                app.myFileName=[app.myFileName '-F7'];
            end
            if app.F5_Button.Value == 1
                app.myFileName=[app.myFileName '-F5'];

            end
            if app.F3_Button.Value == 1
                app.myFileName=[app.myFileName '-F3'];

            end
            
            if app.F1_Button.Value == 1
                app.myFileName=[app.myFileName '-F1'];

            end
            if app.Fz_Button.Value == 1
                app.myFileName=[app.myFileName '-Fz'];

            end
            if app.F2_Button.Value == 1
                app.myFileName=[app.myFileName '-F2'];

            end
            if app.F4_Button.Value == 1
                app.myFileName=[app.myFileName '-F4'];

            end
            if app.F6_Button.Value == 1
                app.myFileName=[app.myFileName '-F6'];

            end
            if app.F8_Button.Value == 1
                app.myFileName=[app.myFileName '-F8'];

            end
            if app.FT7_Button.Value == 1
                app.myFileName=[app.myFileName '-FT7'];

            end
            if app.FC5_Button.Value == 1
                app.myFileName=[app.myFileName '-FC5'];

            end
            
            if app.FC3_Button.Value == 1
                app.myFileName=[app.myFileName '-FC3'];

            end
            if app.FC1_Button.Value == 1
                app.myFileName=[app.myFileName '-FC1'];

            end
            if app.FCz_Button.Value == 1
                app.myFileName=[app.myFileName '-FCz'];

            end
            
            if app.FC2_Button.Value == 1
                app.myFileName=[app.myFileName '-FC2'];

            end
            if app.FC4_Button.Value == 1
                app.myFileName=[app.myFileName '-FC4'];

            end
            if app.FC6_Button.Value == 1
                app.myFileName=[app.myFileName '-FC6'];

            end
            if app.FT8_Button.Value == 1
                app.myFileName=[app.myFileName '-FT8'];

            end
            if app.T7_Button.Value == 1
                app.myFileName=[app.myFileName '-T7'];

            end
            if app.C5_Button.Value == 1
                app.myFileName=[app.myFileName '-C5'];

            end
            if app.C3_Button.Value == 1
                app.myFileName=[app.myFileName '-C3'];

            end
            if app.C1_Button.Value == 1
                app.myFileName=[app.myFileName '-C1'];

            end      
            if app.Cz_Button.Value == 1
                app.myFileName=[app.myFileName '-Cz'];

            end
            if app.C2_Button.Value == 1
                app.myFileName=[app.myFileName '-C2'];

            end
            if app.C4_Button.Value == 1
                app.myFileName=[app.myFileName '-C4'];

            end
            if app.C6_Button.Value == 1
                app.myFileName=[app.myFileName '-C6'];

            end
            if app.T8_Button.Value == 1
                app.myFileName=[app.myFileName '-T8'];

            end
            if app.TP7_Button.Value == 1
                app.myFileName=[app.myFileName '-TP7'];

            end
            if app.CP5_Button.Value == 1
                app.myFileName=[app.myFileName '-CP5'];

            end
            if app.CP3_Button.Value == 1
                app.myFileName=[app.myFileName '-CP3'];

            end
            if app.CP1_Button.Value == 1
                app.myFileName=[app.myFileName '-CP1'];

            end
            if app.CPz_Button.Value == 1
                app.myFileName=[app.myFileName '-CPz'];

            end
            
            if app.CP2_Button.Value == 1
                app.myFileName=[app.myFileName '-CP2'];

            end
            if app.CP4_Button.Value == 1
                app.myFileName=[app.myFileName '-CP4'];

            end
            if app.CP6_Button.Value == 1
                app.myFileName=[app.myFileName '-CP6'];

            end
            if app.TP8_Button.Value == 1
                app.myFileName=[app.myFileName '-TP8'];

            end
            if app.P7_Button.Value == 1
                app.myFileName=[app.myFileName '-P7'];

            end
            if app.P5_Button.Value == 1
                app.myFileName=[app.myFileName '-P5'];

            end
            if app.P3_Button.Value == 1
                app.myFileName=[app.myFileName '-P3'];

                
            end            
            if app.P1_Button.Value == 1
                app.myFileName=[app.myFileName '-P1'];

            end
            if app.Pz_Button.Value == 1
                app.myFileName=[app.myFileName '-Pz'];

            end
            if app.P2_Button.Value == 1
                app.myFileName=[app.myFileName '-P2'];

            end
            if app.P4_Button.Value == 1
                app.myFileName=[app.myFileName '-P4'];

            end
            if app.P6_Button.Value == 1
                app.myFileName=[app.myFileName '-P6'];

            end
            if app.P8_Button.Value == 1
                app.myFileName=[app.myFileName '-P8'];

            end
            if app.PO7_Button.Value == 1
                app.myFileName=[app.myFileName '-PO7'];

            end
            if app.PO3_Button.Value == 1
                app.myFileName=[app.myFileName '-PO3'];

            end
            if app.PO4_Button.Value == 1
                app.myFileName=[app.myFileName '-PO4'];

            end
            if app.PO8_Button.Value == 1
                app.myFileName=[app.myFileName '-PO8'];

            end
            if app.O1_Button.Value == 1
                app.myFileName=[app.myFileName '-O1'];

            end
            if app.Oz_Button.Value == 1
                app.myFileName=[app.myFileName '-Oz'];

            end
            if app.O2_Button.Value == 1
                app.myFileName=[app.myFileName '-O2'];

            end
        end
        
     end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Display image and stretch to fill axes
            I = imshow('im1_ret.png', 'Parent', app.UIAxes,'XData', [1 app.UIAxes.Position(3)],'YData', [1 app.UIAxes.Position(4)]);
            
            app.Cz_Button.Tooltip = 'Cz';
            app.C2_Button.Tooltip = 'C2';
            app.C4_Button.Tooltip = 'C4';
            app.C6_Button.Tooltip = 'C6';
            app.T8_Button.Tooltip = 'T8';
            app.T7_Button.Tooltip = 'T7';
            app.C5_Button.Tooltip = 'C5';
            app.C3_Button.Tooltip = 'C3';
            app.C1_Button.Tooltip = 'C1';
            app.FCz_Button.Tooltip = 'FCz';
            app.Fz_Button.Tooltip = 'Fz';
            app.Fpz_Button.Tooltip = 'Fpz';
            app.Oz_Button.Tooltip = 'Oz';
            app.Pz_Button.Tooltip = 'Pz';
            app.CPz_Button.Tooltip = 'CPz';
            app.FC1_Button.Tooltip = 'FC1';
            app.FC2_Button.Tooltip = 'FC1';
            app.CP1_Button.Tooltip = 'CP1';
            app.CP2_Button.Tooltip = 'CP2';
            app.FC4_Button.Tooltip = 'FC4';
            app.AF4_Button.Tooltip = 'AF4';
            app.FC6_Button.Tooltip = 'FC6';
            app.FT8_Button.Tooltip = 'FT8';
            app.F2_Button.Tooltip = 'F2';
            app.F4_Button.Tooltip = 'F4';
            app.F6_Button.Tooltip = 'F6';
            app.F8_Button.Tooltip = 'F8';
            app.Fp2_Button.Tooltip = 'Fp2';
            app.F3_Button.Tooltip = 'F3';
            app.F7_Button.Tooltip = 'F7';
            app.F5_Button.Tooltip = 'F5';
            app.AF8_Button.Tooltip = 'AF8';
            app.Fp1_Button.Tooltip = 'Fp1';
            app.AF7_Button.Tooltip = 'AF7';
            app.F1_Button.Tooltip = 'F1';
            app.AF3_Button.Tooltip = 'AF3';
            app.TP7_Button.Tooltip = 'TP7';
            app.FC3_Button.Tooltip = 'FC3';
            app.FC5_Button.Tooltip = 'FC5';
            app.FT7_Button.Tooltip = 'FT7';
            app.CP4_Button.Tooltip = 'CP4';
            app.CP6_Button.Tooltip = 'CP6';
            app.TP8_Button.Tooltip = 'TP8';
            app.P2_Button.Tooltip = 'P2';
            app.P4_Button.Tooltip = 'P4';
            app.P6_Button.Tooltip = 'P6';
            app.P8_Button.Tooltip = 'P8';
            app.PO4_Button.Tooltip = 'PO4';
            app.O2_Button.Tooltip = 'O2';
            app.PO8_Button.Tooltip = 'PO8';
            app.CP3_Button.Tooltip = 'CP3';
            app.CP5_Button.Tooltip = 'CP5';
            app.P1_Button.Tooltip = 'P1';
            app.P3_Button.Tooltip = 'P3';
            app.P5_Button.Tooltip = 'P5';
            app.P7_Button.Tooltip = 'P7';
            app.PO3_Button.Tooltip = 'PO3';
            app.O1_Button.Tooltip = 'O1';
            app.PO7_Button.Tooltip = 'PO7';
        end

        % Button pushed function: SelectfileButton
        function SelectfileButtonPushed(app, event)
            %Leemos la cabecera del segmento. Buscamos en ella los datos de interés
            [file,mypath] = uigetfile('*.dat', 'Select One or More Segments',  'MultiSelect', 'on');
            if file==0
                % user pressed cancel
                return
            end
            app.FileAlreadySelected=1;
            if isa(file(1), 'char')
                current_file = fullfile(mypath,file{num});
                fid = fopen(current_file, 'rt');
                %fid = fopen(file, 'rt');
                tline = fgetl(fid);
                fclose(fid);
                mybox=msgbox('Loading'); 
                figure(app.MIAnalysisUIFigure);
                app.FileselectedTextArea.Value = file;
                app.segmentName=file;
                
                oFaceCode = strfind(tline,'FaceCode: ')-2;
                oAudioCode = strfind(tline,'AudioCode: ')-2;
                oAudioFile = strfind(tline,'AudioFile: ')-2;
                oAudioStart = strfind(tline,'AudioStart: ')-2;
                oAudioEnd = strfind(tline,'AudioEnd: ')-2;
                oStimStart = strfind(tline,'StimStart: ')-2;
                number = strfind(file,'_segmento');
                number = number-1;
                app.subject=file(8:number);
                
                iFaceCode = oFaceCode + 12;
                iAudioCode = oAudioCode + 13;
                iAudioFile = oAudioFile + 13;
                iAudioStart = oAudioStart + 14;
                iAudioEnd = oAudioEnd + 12;
                iStimStart = oStimStart + 13;
                
                %Almacenamos los datos de interés en variables
                app.FaceCode = tline(iFaceCode: oAudioCode);
                app.AudioCode = tline(iAudioCode: oAudioFile);
                app.AudioFile = tline(iAudioFile: oAudioStart);
                app.AudioStart = tline(iAudioStart: oStimStart);
                app.StimStart = tline(iStimStart: oAudioEnd);
                app.AudioEnd = tline(iAudioEnd: length(tline));
                
                %Leemos el segmento sin la cabecera
                T = readtable(file);
                [filas, columnas] = size(T);
                cabecera=strings(filas);
                
                for i=1:filas
                    cabecera(i)=string(table2array(T(i,1)));
                end
                
                app.discret=1;
                app.duracion=columnas;

                %Set data of FacetypeTextArea
                
                switch app.FaceCode(2)
                    case '1'
                        app.FacetypeTextArea.Value = 'Woman 1';
                    case '2'
                        app.FacetypeTextArea.Value = 'Woman 2';
                    case '3'
                        app.FacetypeTextArea.Value = 'Man 1';
                    case '4'
                        app.FacetypeTextArea.Value = 'Man 2';
                end
                
                switch app.FaceCode(1)
                    case '1'
                        app.FacetypeTextArea.Value = vertcat(app.FacetypeTextArea.Value,'Face');
                    case '2'
                        app.FacetypeTextArea.Value = vertcat(app.FacetypeTextArea.Value,'Scrambled');
                end
                
                %Set data of AudiotypeTextArea
                
                switch app.AudioCode(1)
                    case '1'
                        app.AudiotypeTextArea.Value = 'Correct';
                        app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['Audio file: ' app.AudioFile]);

                    otherwise
                        app.AudiotypeTextArea.Value = 'Incorrect';
                        if length(app.AudioFile) == 12
                            app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, 'Semantic Error');
                        elseif app.AudioFile(7) == 'i'
                            app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, 'Morphosyntactic Error');
                        end
                        app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['Audio file: ' app.AudioFile]);
%                         app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['wrong word with ', app.AudioCode(2), ' syllables']);
                end
                
                app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['Voice ', app.AudioCode(3)]);
                
                for i=1:filas
                    if cabecera(i)== 'Fp1'
                        app.Fp1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Fpz'
                        app.Fpz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'AF7'
                        app.AF7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'AF3'
                        app.AF3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'AF4'
                        app.AF4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'AF8'
                        app.AF8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F7'
                        app.F7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F5'
                        app.F5 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F3'
                        app.F3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F1'
                        app.F1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Fz'
                        app.Fz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F2'
                        app.F2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F4'
                        app.F4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F6'
                        app.F6 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'F8'
                        app.F8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Fp2'
                        app.Fp2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FT7'
                        app.FT7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC5'
                        app.FC5 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC3'
                        app.FC3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC1'
                        app.FC1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FCz'
                        app.FCz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC2'
                        app.FC2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC4'
                        app.FC4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FC6'
                        app.FC6 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'FT8'
                        app.FT8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'T7'
                        app.T7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C5'
                        app.C5 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C3'
                        app.C3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C1'
                        app.C1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Cz'
                        app.Cz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C2'
                        app.C2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C4'
                        app.C4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'C6'
                        app.C6 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'T8'
                        app.T8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'TP7'
                        app.TP7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP5'
                        app.CP5 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP3'
                        app.CP3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP1'
                        app.CP1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CPz'
                        app.CPz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP2'
                        app.CP2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP4'
                        app.CP4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'CP6'
                        app.CP6 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'TP8'
                        app.TP8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P7'
                        app.P7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P5'
                        app.P5 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P3'
                        app.P3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P1'
                        app.P1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Pz'
                        app.Pz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P2'
                        app.P2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P4'
                        app.P4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P6'
                        app.P6 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'P8'
                        app.P8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'PO7'
                        app.PO7 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'PO3'
                        app.PO3 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'PO4'
                        app.PO4 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'PO8'
                        app.PO8 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'O1'
                        app.O1 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'Oz'
                        app.Oz = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'O2'
                        app.O2 = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'HEOG+'
                        app.HEOGplus = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'HEOG'
                        app.HEOG = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'VEOG+'
                        app.VEOGplus = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'VEOG'
                        app.VEOG = double(table2array(T(i,2:app.discret:columnas)));
                    elseif cabecera(i)== 'M1'
                        app.M1 = double(table2array(T(i,2:app.discret:columnas)));
                    end
                end
            else
                app.FileselectedTextArea.Value = 'Multiple files';
                figure(app.MIAnalysisUIFigure);
                app.FaceCode=double.empty;
                app.AudioCode = double.empty;
                app.AudioFile = double.empty;
                app.AudioStart = double.empty;
                app.AudioEnd = double.empty;
                app.Cz = double.empty(0,431);
                app.C2 = double.empty(0,431);
                app.C4 = double.empty(0,431);
                app.C6 = double.empty(0,431);
                app.T8 = double.empty(0,431);
                app.T7 = double.empty(0,431);
                app.C5 = double.empty(0,431);
                app.C3 = double.empty(0,431);
                app.C1 = double.empty(0,431);
                app.FCz = double.empty(0,431);
                app.Fz = double.empty(0,431);
                app.Fpz = double.empty(0,431);
                app.Oz = double.empty(0,431);
                app.Pz = double.empty(0,431);
                app.CPz = double.empty(0,431);
                app.FC1 = double.empty(0,431);
                app.FC2 = double.empty(0,431);
                app.CP1 = double.empty(0,431);
                app.CP2 = double.empty(0,431);
                app.FC4 = double.empty(0,431);
                app.AF4 = double.empty(0,431);
                app.FC6 = double.empty(0,431);
                app.FT8 = double.empty(0,431);
                app.F2 = double.empty(0,431);
                app.F4 = double.empty(0,431);
                app.F6 = double.empty(0,431);
                app.F8 = double.empty(0,431);
                app.Fp2 = double.empty(0,431);
                app.F3 = double.empty(0,431);
                app.F7 = double.empty(0,431);
                app.F5 = double.empty(0,431);
                app.AF8 = double.empty(0,431);
                app.Fp1 = double.empty(0,431);
                app.AF7 = double.empty(0,431);
                app.F1 = double.empty(0,431);
                app.AF3 = double.empty(0,431);
                app.TP7 = double.empty(0,431);
                app.FC3 = double.empty(0,431);
                app.FC5 = double.empty(0,431);
                app.FT7 = double.empty(0,431);
                app.CP4 = double.empty(0,431);
                app.CP6 = double.empty(0,431);
                app.TP8 = double.empty(0,431);
                app.P2 = double.empty(0,431);
                app.P4 = double.empty(0,431);
                app.P6 = double.empty(0,431);
                app.P8 = double.empty(0,431);
                app.PO4 = double.empty(0,431);
                app.O2 = double.empty(0,431);
                app.PO8 = double.empty(0,431);
                app.CP3 = double.empty(0,431);
                app.CP5 = double.empty(0,431);
                app.P1 = double.empty(0,431);
                app.P3 = double.empty(0,431);
                app.P5 = double.empty(0,431);
                app.P7 = double.empty(0,431);
                app.PO3 = double.empty(0,431);
                app.O1 = double.empty(0,431);
                app.PO7 = double.empty(0,431);
                
                col=zeros(1,length(file));
                for num=1:length(file)
                    current_file = fullfile(mypath,file{num});
                    fid = fopen(current_file, 'rt');
                    tline = fgetl(fid);
                    fclose(fid);
                    T = readtable(current_file);
                    [fil, col(num)] = size(T);
                end
                columnas = min(col);
                for num=1:length(file)
                    current_file = fullfile(mypath,file{num});
                    fid = fopen(current_file, 'rt');
                    tline = fgetl(fid);
                    fclose(fid);
                    
                    oFaceCode = strfind(tline,'FaceCode: ')-2;
                    oAudioCode = strfind(tline,'AudioCode: ')-2;
                    oAudioFile = strfind(tline,'AudioFile: ')-2;
                    oAudioStart = strfind(tline,'AudioStart: ')-2;
                    oAudioEnd = strfind(tline,'AudioEnd: ')-2;
                    
                    iFaceCode = oFaceCode + 12;
                    iAudioCode = oAudioCode + 13;
                    iAudioFile = oAudioFile + 13;
                    iAudioStart = oAudioStart + 14;
                    iAudioEnd = oAudioEnd + 12;
                    
                    %Almacenamos los datos de interés en variables
                    tline(iFaceCode: oAudioCode);
                    app.FaceCode(num) = str2double(tline(iFaceCode: oAudioCode));
                    app.AudioCode(num) = str2double(tline(iAudioCode: oAudioFile));
                    app.AudioFile(num) = str2double(tline(iAudioFile: oAudioStart));
                    app.AudioStart(num) = str2double(tline(iAudioStart: oAudioEnd));
                    app.AudioEnd(num) = str2double(tline(iAudioEnd: length(tline)));
                    
                    %Leemos el segmento sin la cabecera
                    %current_file;
                    T = readtable(current_file);
                    [filas, cols] = size(T);
                    cabecera=strings(filas);
                    
                    for i=1:filas
                        cabecera(i)=string(table2array(T(i,1)));
                    end
                    
                    app.discret=1;
                    
                    
                    for i=1:filas
                        if cabecera(i)== 'Fp1'
                            app.Fp1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Fpz'
                            app.Fpz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'AF7'
                            app.AF7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'AF3'
                            app.AF3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'AF4'
                            app.AF4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'AF8'
                            app.AF8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F7'
                            app.F7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F5'
                            app.F5(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F3'
                            app.F3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F1'
                            app.F1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Fz'
                            app.Fz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F2'
                            app.F2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F4'
                            app.F4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F6'
                            app.F6(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'F8'
                            app.F8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Fp2'
                            app.Fp2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FT7'
                            app.FT7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC5'
                            app.FC5(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC3'
                            app.FC3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC1'
                            app.FC1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FCz'
                            app.FCz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC2'
                            app.FC2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC4'
                            app.FC4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FC6'
                            app.FC6(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'FT8'
                            app.FT8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'T7'
                            app.T7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C5'
                            app.C5(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C3'
                            app.C3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C1'
                            app.C1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Cz'
                            app.Cz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C2'
                            app.C2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C4'
                            app.C4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'C6'
                            app.C6(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'T8'
                            app.T8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'TP7'
                            app.TP7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP5'
                            app.CP5(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP3'
                            app.CP3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP1'
                            app.CP1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CPz'
                            app.CPz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP2'
                            app.CP2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP4'
                            app.CP4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'CP6'
                            app.CP6(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'TP8'
                            app.TP8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P7'
                            app.P7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P5'
                            app.P5(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P3'
                            app.P3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P1'
                            app.P1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Pz'
                            app.Pz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P2'
                            app.P2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P4'
                            app.P4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P6'
                            app.P6(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'P8'
                            app.P8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'PO7'
                            app.PO7(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'PO3'
                            app.PO3(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'PO4'
                            app.PO4(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'PO8'
                            app.PO8(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'O1'
                            app.O1(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'Oz'
                            app.Oz(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
                        elseif cabecera(i)== 'O2'
                            app.O2(num,1:columnas-1) = double(table2array(T(i,2:app.discret:columnas)));
%                         elseif cabecera(i)== 'HEOG+'
%                             HEOGplus(num,:) = double(table2array(T(i,2:app.discret:columnas)));
%                         elseif cabecera(i)== 'HEOG'
%                             HEOG(num,:) = double(table2array(T(i,2:app.discret:columnas)));
%                         elseif cabecera(i)== 'VEOG+'
%                             VEOGplus(num,:) = double(table2array(T(i,2:app.discret:columnas)));
%                         elseif cabecera(i)== 'VEOG'
%                             VEOG(num,:) = double(table2array(T(i,2:app.discret:columnas)));
%                         elseif cabecera(i)== 'M1'
%                             M1(num,:) = double(table2array(T(i,2:app.discret:columnas)));
                        end
                    end
                    clear T;
                end
                %Get the means of each channel
                
                
                

%                         app.FacetypeTextArea.Value = 'Man 2';
% 
%                         app.FacetypeTextArea.Value = vertcat(app.FacetypeTextArea.Value,'Scrambled');

                
                %Set data of AudiotypeTextArea

                        app.AudiotypeTextArea.Value = 'Different audios';
                        app.FacetypeTextArea.Value = 'Different faces';
                
                app.Cz = mean(app.Cz);
                app.C2 = mean(app.C2);
                app.C4 = mean(app.C4);
                app.C6 = mean(app.C6);
                app.T8 = mean(app.T8);
                app.T7 = mean(app.T7);
                app.C5 = mean(app.C5);
                app.C3 = mean(app.C3);
                app.C1 = mean(app.C1);
                app.FCz = mean(app.FCz);
                app.Fz = mean(app.Fz);
                app.Fpz = mean(app.Fpz);
                app.Oz = mean(app.Oz);
                app.Pz = mean(app.Pz);
                app.CPz = mean(app.CPz);
                app.FC1 = mean(app.FC1);
                app.FC2 = mean(app.FC2);
                app.CP1 = mean(app.CP1);
                app.CP2 = mean(app.CP2);
                app.FC4 = mean(app.FC4);
                app.AF4 = mean(app.AF4);
                app.FC6 = mean(app.FC6);
                app.FT8 = mean(app.FT8);
                app.F2 = mean(app.F2);
                app.F4 = mean(app.F4);
                app.F6 = mean(app.F6);
                app.F8 = mean(app.F8);
                app.Fp2 = mean(app.Fp2);
                app.F3 = mean(app.F3);
                app.F7 = mean(app.F7);
                app.F5 = mean(app.F5);
                app.AF8 = mean(app.AF8);
                app.Fp1 = mean(app.Fp1);
                app.AF7 = mean(app.AF7);
                app.F1 = mean(app.F1);
                app.AF3 = mean(app.AF3);
                app.TP7 = mean(app.TP7);
                app.FC3 = mean(app.FC3);
                app.FC5 = mean(app.FC5);
                app.FT7 = mean(app.FT7);
                app.CP4 = mean(app.CP4);
                app.CP6 = mean(app.CP6);
                app.TP8 = mean(app.TP8);
                app.P2 = mean(app.P2);
                app.P4 = mean(app.P4);
                app.P6 = mean(app.P6);
                app.P8 = mean(app.P8);
                app.PO4 = mean(app.PO4);
                app.O2 = mean(app.O2);
                app.PO8 = mean(app.PO8);
                app.CP3 = mean(app.CP3);
                app.CP5 = mean(app.CP5);
                app.P1 = mean(app.P1);
                app.P3 = mean(app.P3);
                app.P5 = mean(app.P5);
                app.P7 = mean(app.P7);
                app.PO3 = mean(app.PO3);
                app.O1 = mean(app.PO3);
                app.PO7 = mean(app.PO7);
                
                
                %Set data of FacetypeTextArea
                
%                 switch FaceCode(2)
%                     case '1'
%                         app.FacetypeTextArea.Value = 'Woman 1';
%                     case '2'
%                         app.FacetypeTextArea.Value = 'Woman 2';
%                     case '3'
%                         app.FacetypeTextArea.Value = 'Man 1';
%                     case '4'
%                         app.FacetypeTextArea.Value = 'Man 2';
%                 end
%                 
%                 switch FaceCode(1)
%                     case '1'
%                         app.FacetypeTextArea.Value = vertcat(app.FacetypeTextArea.Value,'Face');
%                     case '2'
%                         app.FacetypeTextArea.Value = vertcat(app.FacetypeTextArea.Value,'Scrambled');
%                 end
                
                %Set data of AudiotypeTextArea
                
%                 switch AudioCode(1)
%                     case '1'
%                         app.AudiotypeTextArea.Value = 'Correct';
%                         app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value);
%                     otherwise
%                         app.AudiotypeTextArea.Value = 'Incorrect';
%                         app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['wrong word with ', AudioCode(2), ' syllables']);
%                 end
                
%                 app.AudiotypeTextArea.Value = vertcat(app.AudiotypeTextArea.Value, ['Voice ', AudioCode(3)]);
                
            end
            close(mybox);
            filter_signals(app);
            
        end

        % Callback function
        function DiscretizationDropDownValueChanged(app, event)
            app.discretization = app.DiscretizationDropDown.Value;
            if app.discretization==100
                app.discret=1;
            elseif app.discretization==50
                app.discret=2;
            elseif app.discretization==25
                app.discret=4;
            end
          
        end

        % Callback function
        function DiscretizeCheckBoxValueChanged(app, event)
            value = app.DiscretizeCheckBox.Value;
            if value == 1
                app.DiscretizationDropDown.Enable = 'on';
                app.DiscretizationDropDownLabel.Enable = 'on';
            else
                app.DiscretizationDropDown.Enable = 'off';
                app.DiscretizationDropDownLabel.Enable = 'off';
            end
            
        end

        % Button pushed function: PrintButton
        function PrintButtonPushed(app, event)
            app.FileselectedTextArea.Value
            if app.FileAlreadySelected == 0
                warndlg('Please select any file')
            end
            
            reset(app.UIAxes2);
            app.UIAxes2.cla;
            app.printed=1;
            
            
            
            switch app.filter
                case 0
                    switch app.ShowDropDown.Value
                        case 'Tension signal'
                            print_tension(app)
                            title(app.UIAxes2,'Tension signal');
                        case 'Mean values'
                            print_histogram(app)
                            title(app.UIAxes2,'Mean values');
                    end
                case 1
                    switch app.ShowDropDown.Value
                        case 'Tension signal'
                            set(app.UIAxes2,'XTick',[])
                            print_filtred_tension(app)
                            title(app.UIAxes2,['Tension signal: ', app.BandselectionDropDown_2.Value, ' band']);
                        case 'Mean values'
                            print_filtred_histogram(app)
                            title(app.UIAxes2,['Mean values: ', app.BandselectionDropDown_2.Value, ' band']);
                    end
            end
            
        end

        % Value changed function: SelectallCheckBox
        function SelectallCheckBoxValueChanged(app, event)
            value = app.SelectallCheckBox.Value;
            if value ==1
                app.Cz_Button.Value = 1;
                app.C2_Button.Value = 1;
                app.C4_Button.Value = 1;
                app.C6_Button.Value = 1;
                app.T8_Button.Value = 1;
                app.T7_Button.Value = 1;
                app.C5_Button.Value = 1;
                app.C3_Button.Value = 1;
                app.C1_Button.Value = 1;
                app.FCz_Button.Value = 1;
                app.Fz_Button.Value = 1;
                app.Fpz_Button.Value = 1;
                app.Oz_Button.Value = 1;
                app.Pz_Button.Value = 1;
                app.CPz_Button.Value = 1;
                app.FC1_Button.Value = 1;
                app.FC2_Button.Value = 1;
                app.CP1_Button.Value = 1;
                app.CP2_Button.Value = 1;
                app.FC4_Button.Value = 1;
                app.AF4_Button.Value = 1;
                app.FC6_Button.Value = 1;
                app.FT8_Button.Value = 1;
                app.F2_Button.Value = 1;
                app.F4_Button.Value = 1;
                app.F6_Button.Value = 1;
                app.F8_Button.Value = 1;
                app.Fp2_Button.Value = 1;
                app.F3_Button.Value = 1;
                app.F7_Button.Value = 1;
                app.F5_Button.Value = 1;
                app.AF8_Button.Value = 1;
                app.Fp1_Button.Value = 1;
                app.AF7_Button.Value = 1;
                app.F1_Button.Value = 1;
                app.AF3_Button.Value = 1;
                app.TP7_Button.Value = 1;
                app.FC3_Button.Value = 1;
                app.FC5_Button.Value = 1;
                app.FT7_Button.Value = 1;
                app.CP4_Button.Value = 1;
                app.CP6_Button.Value = 1;
                app.TP8_Button.Value = 1;
                app.P2_Button.Value = 1;
                app.P4_Button.Value = 1;
                app.P6_Button.Value = 1;
                app.P8_Button.Value = 1;
                app.PO4_Button.Value = 1;
                app.O2_Button.Value = 1;
                app.PO8_Button.Value = 1;
                app.CP3_Button.Value = 1;
                app.CP5_Button.Value = 1;
                app.P1_Button.Value = 1;
                app.P3_Button.Value = 1;
                app.P5_Button.Value = 1;
                app.P7_Button.Value = 1;
                app.PO3_Button.Value = 1;
                app.O1_Button.Value = 1;
                app.PO7_Button.Value = 1;
            else
                app.Cz_Button.Value = 0;
                app.C2_Button.Value = 0;
                app.C4_Button.Value = 0;
                app.C6_Button.Value = 0;
                app.T8_Button.Value = 0;
                app.T7_Button.Value = 0;
                app.C5_Button.Value = 0;
                app.C3_Button.Value = 0;
                app.C1_Button.Value = 0;
                app.FCz_Button.Value = 0;
                app.Fz_Button.Value = 0;
                app.Fpz_Button.Value = 0;
                app.Oz_Button.Value = 0;
                app.Pz_Button.Value = 0;
                app.CPz_Button.Value = 0;
                app.FC1_Button.Value = 0;
                app.FC2_Button.Value = 0;
                app.CP1_Button.Value = 0;
                app.CP2_Button.Value = 0;
                app.FC4_Button.Value = 0;
                app.AF4_Button.Value = 0;
                app.FC6_Button.Value = 0;
                app.FT8_Button.Value = 0;
                app.F2_Button.Value = 0;
                app.F4_Button.Value = 0;
                app.F6_Button.Value = 0;
                app.F8_Button.Value = 0;
                app.Fp2_Button.Value = 0;
                app.F3_Button.Value = 0;
                app.F7_Button.Value = 0;
                app.F5_Button.Value = 0;
                app.AF8_Button.Value = 0;
                app.Fp1_Button.Value = 0;
                app.AF7_Button.Value = 0;
                app.F1_Button.Value = 0;
                app.AF3_Button.Value = 0;
                app.TP7_Button.Value = 0;
                app.FC3_Button.Value = 0;
                app.FC5_Button.Value = 0;
                app.FT7_Button.Value = 0;
                app.CP4_Button.Value = 0;
                app.CP6_Button.Value = 0;
                app.TP8_Button.Value = 0;
                app.P2_Button.Value = 0;
                app.P4_Button.Value = 0;
                app.P6_Button.Value = 0;
                app.P8_Button.Value = 0;
                app.PO4_Button.Value = 0;
                app.O2_Button.Value = 0;
                app.PO8_Button.Value = 0;
                app.CP3_Button.Value = 0;
                app.CP5_Button.Value = 0;
                app.P1_Button.Value = 0;
                app.P3_Button.Value = 0;
                app.P5_Button.Value = 0;
                app.P7_Button.Value = 0;
                app.PO3_Button.Value = 0;
                app.O1_Button.Value = 0;
                app.PO7_Button.Value = 0;
            end
            
            
            
        end

        % Value changed function: BandselectionDropDown_2
        function BandselectionDropDown_2ValueChanged(app, event)
            value = app.BandselectionDropDown_2.Value;
            if length(value) == 5
                app.wn=app.wn_delta;
            elseif length(value) == 9
                app.wn=app.wn_thetal;
            elseif length(value) == 10
                app.wn=app.wn_thetah;
            end
            
            if app.filter==1
                filter_signals(app);
            end
            
        end

        % Value changed function: FilterCheckBox
        function FilterCheckBoxValueChanged(app, event)
            value = app.FilterCheckBox.Value;
            if value ==1
                app.filter=1;             
            else
                app.filter=0;
            end
            filter_signals(app);
            if app.ShowROICheckBox.Value==1
                calculateAllMIs(app);
                unprint(app);
                printROIs(app);
            end
        end

        % Button pushed function: CleanButton
        function CleanButtonPushed(app, event)
            app.UIAxes2.cla;
            title(app.UIAxes2,'')
            app.printed=0;
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed2(app, event)
            if app.FileAlreadySelected == 0
                warndlg('Please select any file')
            end
            mybox=msgbox('Saving image'); 
            createFigure(app);
%             xlabel(app.UIAxes2, 'Time (seconds)');
%             ylabel(app.UIAxes2, 'Voltage (microvolts)');
%             title(app.UIAxes2,'Tension signal');
            getname(app);
            
            hora=datestr(now,'HH:MM:SS');
            FileName=[app.myFileName,' ', app.type,datestr(now, 'dd-mmm-yyyy'),' ',hora(1:2),'-',hora(4:5),'-',hora(7:8),'.png'];
            FileName=fullfile(mypath,'Saved Images',FileName);
            mydir=fullfile(mypath,'Saved Images');
            mkdir(mydir);
            saveas(app.myFigure,FileName);
            close (mybox);
            msgbox('Image saved');
            PrintButtonPushed(app);
             
        end

        % Button pushed function: GeneratereportButton
        function GeneratereportButtonPushed(app, event)
            if app.FileAlreadySelected == 0
                warndlg('Please select any file')
            end
            getname(app);
            
            hora=datestr(now,'HH:MM:SS');
            FileName=[datestr(now, 'dd-mmm-yyyy'),' ',hora(1:2),'-',hora(4:5),'-',hora(7:8),  ' ', app.myFileName];
            FileName=fullfile(mypath,FileName);
            if length(app.ReportformatDropDown.Value) == 3 %is txt
                mybox=msgbox('Generating report in reports/txt/');
%                 [myaudio,Fs] = audioread(['audios/Stimuli/' app.AudioFile]);
%                 hist1=myproces(app.AF3);
%                 hist1=hist1.Values;
%                 hist2=myproces(myaudio);
%                 hist2=hist2.Values;
%                 [entropy1 prob1]=myentropy(hist1);
%                 [entropy2 prob2]=myentropy(hist2);
%                 MI=myMI(entropy1,prob1,prob2);
                MI=obtainMI(app,app.AF3);
                mkdir('reports/txt');
                reportname=FileName;
                FileName=['reports/txt/' FileName];
                fileID = fopen([FileName '.txt'],'w');
                typeIntotxt(app,fileID)
                close (mybox);
                msgbox(['Report created: ', reportname]);
                fclose(fileID);
            elseif length(app.ReportformatDropDown.Value) == 4 %word
                mybox=msgbox('Generating report in reports/word/');
%                 [myaudio,Fs] = audioread(['audios/Stimuli/' app.AudioFile]);
%                 hist1=myproces(app.AF3);
%                 hist1=hist1.Values;
%                 hist2=myproces(myaudio);
%                 hist2=hist2.Values;
%                 [entropy1 prob1]=myentropy(hist1);
%                 [entropy2 prob2]=myentropy(hist2);
%                 MI=myMI(entropy1,prob1,prob2);              
                
                word = actxserver('Word.Application');      %start Word
%                 word.Visible =1;                            %make Word Visible
                document=word.Documents.Add;
                selection=word.Selection;
                typeIntoWord(app,selection);
                if app.printed==1 %print figure into word
                    switch app.ShowDropDown.Value
                        case 'Tension signal'
                            selection.TypeText('Tension signal: ');
                        case 'Mean values'
                            selection.TypeText('Mean values: ');
                    end
                    
                    createFigure(app);
                    print(app.myFigure,'-dmeta');                 %print figure to clipboard
                    invoke(word.Selection,'Paste');             %paste figure to Word
                end
                
                if length(app.ShowDropDown.Value) == 11 %Mean values
                    selection.TypeText('Histogram: ');
                    newFigure = figure;
                    newFigure.Visible = 'off';
                    histogram(app.signals_ploted);
                    print(newFigure,'-dmeta');
                    invoke(word.Selection,'Paste');
                end
                    
                mkdir('reports/word');
                reportname=FileName;
                FileName=['/reports/word/' FileName];
                document.SaveAs2([pwd ['/' FileName '.doc']]);         %save Document
                word.Quit();
                close (mybox);
                msgbox(['Report created: ', reportname]);
                
            elseif length(app.ReportformatDropDown.Value) == 5 %excel
                mybox=msgbox('Generating report in reports/excel/');
                reportName=typeIntoXslx(app);
                close (mybox);
                msgbox(['Report created: ',reportName]);
                PrintButtonPushed(app);
            end
        end

        % Callback function
        function NumberodROIsDropDownValueChanged(app, event)
            
        end

        % Value changed function: ShowROICheckBox
        function ShowROICheckBoxValueChanged(app, event)
            value = app.ShowROICheckBox.Value;
            if value==1
                calculateAllMIs(app);
                printROIs(app);
                
            end
            if value==0
                unprint(app);
            end
                
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MIAnalysisUIFigure and hide until all components are created
            app.MIAnalysisUIFigure = uifigure('Visible', 'off');
            app.MIAnalysisUIFigure.AutoResizeChildren = 'off';
            app.MIAnalysisUIFigure.Position = [100 100 963 659];
            app.MIAnalysisUIFigure.Name = 'MI Analysis';

            % Create UIAxes
            app.UIAxes = uiaxes(app.MIAnalysisUIFigure);
            app.UIAxes.DataAspectRatio = [1 1 1];
            app.UIAxes.PlotBoxAspectRatio = [1 1.06865671641791 1];
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.MinorGridAlpha = 0.25;
            app.UIAxes.Position = [285 264 360 383];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.MIAnalysisUIFigure);
            app.UIAxes2.PlotBoxAspectRatio = [1.99206349206349 1 1];
            app.UIAxes2.Position = [159 3 751 285];

            % Create SelectfileButton
            app.SelectfileButton = uibutton(app.MIAnalysisUIFigure, 'push');
            app.SelectfileButton.ButtonPushedFcn = createCallbackFcn(app, @SelectfileButtonPushed, true);
            app.SelectfileButton.Position = [15 623 92 22];
            app.SelectfileButton.Text = 'Select file';

            % Create Cz_Button
            app.Cz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Cz_Button.Text = '*';
            app.Cz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Cz_Button.Position = [441 443 15 18];

            % Create C2_Button
            app.C2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C2_Button.Text = '*';
            app.C2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C2_Button.Position = [471 443 15 18];

            % Create C4_Button
            app.C4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C4_Button.Text = '*';
            app.C4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C4_Button.Position = [501 443 15 18];

            % Create C6_Button
            app.C6_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C6_Button.Text = '*';
            app.C6_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C6_Button.Position = [529 443 15 18];

            % Create T8_Button
            app.T8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.T8_Button.Text = '*';
            app.T8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.T8_Button.Position = [559 443 15 18];

            % Create T7_Button
            app.T7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.T7_Button.Text = '*';
            app.T7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.T7_Button.Position = [323 443 15 18];

            % Create C5_Button
            app.C5_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C5_Button.Text = '*';
            app.C5_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C5_Button.Position = [353 443 15 18];

            % Create C3_Button
            app.C3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C3_Button.Text = '*';
            app.C3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C3_Button.Position = [381 443 15 18];

            % Create C1_Button
            app.C1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.C1_Button.Text = '*';
            app.C1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.C1_Button.Position = [411 443 15 18];

            % Create FCz_Button
            app.FCz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FCz_Button.Text = '*';
            app.FCz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FCz_Button.Position = [441 471 15 18];

            % Create Fz_Button
            app.Fz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Fz_Button.Text = '*';
            app.Fz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Fz_Button.Position = [441 499 15 18];

            % Create Fpz_Button
            app.Fpz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Fpz_Button.Text = '*';
            app.Fpz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Fpz_Button.Position = [441 555 15 18];

            % Create Oz_Button
            app.Oz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Oz_Button.Text = '*';
            app.Oz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Oz_Button.Position = [441 329 15 18];

            % Create Pz_Button
            app.Pz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Pz_Button.Text = '*';
            app.Pz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Pz_Button.Position = [441 385 15 18];

            % Create CPz_Button
            app.CPz_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CPz_Button.Text = '*';
            app.CPz_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CPz_Button.Position = [441 413 15 18];

            % Create FC1_Button
            app.FC1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC1_Button.Text = '*';
            app.FC1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC1_Button.Position = [413 471 15 18];

            % Create FC2_Button
            app.FC2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC2_Button.Text = '*';
            app.FC2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC2_Button.Position = [468 471 15 18];

            % Create CP1_Button
            app.CP1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP1_Button.Text = '*';
            app.CP1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP1_Button.Position = [413 413 15 18];

            % Create CP2_Button
            app.CP2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP2_Button.Text = '*';
            app.CP2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP2_Button.Position = [468 413 15 18];

            % Create FC4_Button
            app.FC4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC4_Button.Text = '*';
            app.FC4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC4_Button.Position = [496 473 15 18];

            % Create AF4_Button
            app.AF4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.AF4_Button.Text = '*';
            app.AF4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AF4_Button.Position = [474 527 15 18];

            % Create FC6_Button
            app.FC6_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC6_Button.Text = '*';
            app.FC6_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC6_Button.Position = [525 475 15 18];

            % Create FT8_Button
            app.FT8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FT8_Button.Text = '*';
            app.FT8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FT8_Button.Position = [553 479 15 18];

            % Create F2_Button
            app.F2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F2_Button.Text = '*';
            app.F2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F2_Button.Position = [463 500 15 18];

            % Create F4_Button
            app.F4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F4_Button.Text = '*';
            app.F4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F4_Button.Position = [488 503 15 18];

            % Create F6_Button
            app.F6_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F6_Button.Text = '*';
            app.F6_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F6_Button.Position = [513 507 15 18];

            % Create F8_Button
            app.F8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F8_Button.Text = '*';
            app.F8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F8_Button.Position = [537 512 15 18];

            % Create Fp2_Button
            app.Fp2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Fp2_Button.Text = '*';
            app.Fp2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Fp2_Button.Position = [476 550 15 18];

            % Create F3_Button
            app.F3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F3_Button.Text = '*';
            app.F3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F3_Button.Position = [394 503 15 18];

            % Create F7_Button
            app.F7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F7_Button.Text = '*';
            app.F7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F7_Button.Position = [345 512 15 18];

            % Create F5_Button
            app.F5_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F5_Button.Text = '*';
            app.F5_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F5_Button.Position = [369 507 15 18];

            % Create AF8_Button
            app.AF8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.AF8_Button.Text = '*';
            app.AF8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AF8_Button.Position = [510 535 15 18];

            % Create Fp1_Button
            app.Fp1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.Fp1_Button.Text = '*';
            app.Fp1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Fp1_Button.Position = [406 550 15 18];

            % Create AF7_Button
            app.AF7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.AF7_Button.Text = '*';
            app.AF7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AF7_Button.Position = [372 535 15 18];

            % Create F1_Button
            app.F1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.F1_Button.Text = '*';
            app.F1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.F1_Button.Position = [419 500 15 18];

            % Create AF3_Button
            app.AF3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.AF3_Button.Text = '*';
            app.AF3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.AF3_Button.Position = [408 527 15 18];

            % Create TP7_Button
            app.TP7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.TP7_Button.Text = '*';
            app.TP7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TP7_Button.Position = [329 408 15 18];

            % Create FC3_Button
            app.FC3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC3_Button.Text = '*';
            app.FC3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC3_Button.Position = [386 471 15 18];

            % Create FC5_Button
            app.FC5_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FC5_Button.Text = '*';
            app.FC5_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FC5_Button.Position = [357 473 15 18];

            % Create FT7_Button
            app.FT7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.FT7_Button.Text = '*';
            app.FT7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FT7_Button.Position = [331 479 15 18];

            % Create CP4_Button
            app.CP4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP4_Button.Text = '*';
            app.CP4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP4_Button.Position = [496 411 15 18];

            % Create CP6_Button
            app.CP6_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP6_Button.Text = '*';
            app.CP6_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP6_Button.Position = [525 409 15 18];

            % Create TP8_Button
            app.TP8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.TP8_Button.Text = '*';
            app.TP8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TP8_Button.Position = [553 405 15 18];

            % Create P2_Button
            app.P2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P2_Button.Text = '*';
            app.P2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P2_Button.Position = [463 385 15 18];

            % Create P4_Button
            app.P4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P4_Button.Text = '*';
            app.P4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P4_Button.Position = [488 383 15 18];

            % Create P6_Button
            app.P6_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P6_Button.Text = '*';
            app.P6_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P6_Button.Position = [513 379 15 18];

            % Create P8_Button
            app.P8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P8_Button.Text = '*';
            app.P8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P8_Button.Position = [537 374 15 18];

            % Create PO4_Button
            app.PO4_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.PO4_Button.Text = '*';
            app.PO4_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PO4_Button.Position = [474 362 15 18];

            % Create O2_Button
            app.O2_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.O2_Button.Text = '*';
            app.O2_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.O2_Button.Position = [476 334 15 18];

            % Create PO8_Button
            app.PO8_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.PO8_Button.Text = '*';
            app.PO8_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PO8_Button.Position = [510 349 15 18];

            % Create CP3_Button
            app.CP3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP3_Button.Text = '*';
            app.CP3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP3_Button.Position = [386 413 15 18];

            % Create CP5_Button
            app.CP5_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.CP5_Button.Text = '*';
            app.CP5_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CP5_Button.Position = [357 411 15 18];

            % Create P1_Button
            app.P1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P1_Button.Text = '*';
            app.P1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P1_Button.Position = [419 385 15 18];

            % Create P3_Button
            app.P3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P3_Button.Text = '*';
            app.P3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P3_Button.Position = [394 383 15 18];

            % Create P5_Button
            app.P5_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P5_Button.Text = '*';
            app.P5_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P5_Button.Position = [367 379 15 18];

            % Create P7_Button
            app.P7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.P7_Button.Text = '*';
            app.P7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.P7_Button.Position = [345 374 15 18];

            % Create PO3_Button
            app.PO3_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.PO3_Button.Text = '*';
            app.PO3_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PO3_Button.Position = [407 361 15 18];

            % Create O1_Button
            app.O1_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.O1_Button.Text = '*';
            app.O1_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.O1_Button.Position = [404 334 15 18];

            % Create PO7_Button
            app.PO7_Button = uibutton(app.MIAnalysisUIFigure, 'state');
            app.PO7_Button.Text = '*';
            app.PO7_Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PO7_Button.Position = [372 350 15 18];

            % Create SelectallCheckBox
            app.SelectallCheckBox = uicheckbox(app.MIAnalysisUIFigure);
            app.SelectallCheckBox.ValueChangedFcn = createCallbackFcn(app, @SelectallCheckBoxValueChanged, true);
            app.SelectallCheckBox.Text = 'Select all';
            app.SelectallCheckBox.Position = [303 602 71 22];

            % Create FilterPanel
            app.FilterPanel = uipanel(app.MIAnalysisUIFigure);
            app.FilterPanel.AutoResizeChildren = 'off';
            app.FilterPanel.Title = 'Filter';
            app.FilterPanel.Position = [8 443 255 130];

            % Create BandselectionDropDown_2Label
            app.BandselectionDropDown_2Label = uilabel(app.FilterPanel);
            app.BandselectionDropDown_2Label.HorizontalAlignment = 'right';
            app.BandselectionDropDown_2Label.Position = [39 67 84 22];
            app.BandselectionDropDown_2Label.Text = 'Band selection';

            % Create BandselectionDropDown_2
            app.BandselectionDropDown_2 = uidropdown(app.FilterPanel);
            app.BandselectionDropDown_2.Items = {'delta', 'theta low', 'theta high'};
            app.BandselectionDropDown_2.ValueChangedFcn = createCallbackFcn(app, @BandselectionDropDown_2ValueChanged, true);
            app.BandselectionDropDown_2.Position = [138 67 100 22];
            app.BandselectionDropDown_2.Value = 'delta';

            % Create FilterCheckBox
            app.FilterCheckBox = uicheckbox(app.FilterPanel);
            app.FilterCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterCheckBoxValueChanged, true);
            app.FilterCheckBox.Text = 'Filter';
            app.FilterCheckBox.Position = [43 30 49 22];

            % Create FileselectedTextAreaLabel
            app.FileselectedTextAreaLabel = uilabel(app.MIAnalysisUIFigure);
            app.FileselectedTextAreaLabel.HorizontalAlignment = 'right';
            app.FileselectedTextAreaLabel.Position = [8 585 76 22];
            app.FileselectedTextAreaLabel.Text = 'File selected:';

            % Create FileselectedTextArea
            app.FileselectedTextArea = uitextarea(app.MIAnalysisUIFigure);
            app.FileselectedTextArea.Editable = 'off';
            app.FileselectedTextArea.Position = [92 582 171 27];

            % Create CleanButton
            app.CleanButton = uibutton(app.MIAnalysisUIFigure, 'push');
            app.CleanButton.ButtonPushedFcn = createCallbackFcn(app, @CleanButtonPushed, true);
            app.CleanButton.Position = [51 174 100 22];
            app.CleanButton.Text = 'Clean';

            % Create SegmentdataPanel
            app.SegmentdataPanel = uipanel(app.MIAnalysisUIFigure);
            app.SegmentdataPanel.AutoResizeChildren = 'off';
            app.SegmentdataPanel.Title = 'Segment data';
            app.SegmentdataPanel.Position = [688 473 260 157];

            % Create FacetypeTextAreaLabel
            app.FacetypeTextAreaLabel = uilabel(app.SegmentdataPanel);
            app.FacetypeTextAreaLabel.HorizontalAlignment = 'right';
            app.FacetypeTextAreaLabel.Position = [6 105 62 22];
            app.FacetypeTextAreaLabel.Text = 'Face type:';

            % Create FacetypeTextArea
            app.FacetypeTextArea = uitextarea(app.SegmentdataPanel);
            app.FacetypeTextArea.Editable = 'off';
            app.FacetypeTextArea.Position = [83 85 167 44];

            % Create AudiotypeTextAreaLabel
            app.AudiotypeTextAreaLabel = uilabel(app.SegmentdataPanel);
            app.AudiotypeTextAreaLabel.HorizontalAlignment = 'right';
            app.AudiotypeTextAreaLabel.Position = [1 46 66 22];
            app.AudiotypeTextAreaLabel.Text = 'Audio type:';

            % Create AudiotypeTextArea
            app.AudiotypeTextArea = uitextarea(app.SegmentdataPanel);
            app.AudiotypeTextArea.Editable = 'off';
            app.AudiotypeTextArea.Position = [82 15 167 55];

            % Create SaveButton
            app.SaveButton = uibutton(app.MIAnalysisUIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed2, true);
            app.SaveButton.Position = [51 88 100 22];
            app.SaveButton.Text = 'Save';

            % Create ReportPanel
            app.ReportPanel = uipanel(app.MIAnalysisUIFigure);
            app.ReportPanel.AutoResizeChildren = 'off';
            app.ReportPanel.Title = 'Report';
            app.ReportPanel.Position = [689 327 255 104];

            % Create GeneratereportButton
            app.GeneratereportButton = uibutton(app.ReportPanel, 'push');
            app.GeneratereportButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratereportButtonPushed, true);
            app.GeneratereportButton.Position = [110 10 100 22];
            app.GeneratereportButton.Text = 'Generate report';

            % Create ReportformatDropDownLabel
            app.ReportformatDropDownLabel = uilabel(app.ReportPanel);
            app.ReportformatDropDownLabel.HorizontalAlignment = 'right';
            app.ReportformatDropDownLabel.Position = [16 50 79 22];
            app.ReportformatDropDownLabel.Text = 'Report format';

            % Create ReportformatDropDown
            app.ReportformatDropDown = uidropdown(app.ReportPanel);
            app.ReportformatDropDown.Items = {'word', 'txt', 'excel'};
            app.ReportformatDropDown.Position = [110 50 100 22];
            app.ReportformatDropDown.Value = 'word';

            % Create ROIRegionsofInterestPanel
            app.ROIRegionsofInterestPanel = uipanel(app.MIAnalysisUIFigure);
            app.ROIRegionsofInterestPanel.AutoResizeChildren = 'off';
            app.ROIRegionsofInterestPanel.Title = 'ROI (Regions of Interest)';
            app.ROIRegionsofInterestPanel.Position = [6 287 257 57];

            % Create ShowROICheckBox
            app.ShowROICheckBox = uicheckbox(app.ROIRegionsofInterestPanel);
            app.ShowROICheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowROICheckBoxValueChanged, true);
            app.ShowROICheckBox.Text = 'Show ROI';
            app.ShowROICheckBox.Position = [10 8 77 22];

            % Create StudyFieldPanel
            app.StudyFieldPanel = uipanel(app.MIAnalysisUIFigure);
            app.StudyFieldPanel.AutoResizeChildren = 'off';
            app.StudyFieldPanel.Title = 'Study Field';
            app.StudyFieldPanel.Position = [8 349 255 82];

            % Create ShowLabel
            app.ShowLabel = uilabel(app.StudyFieldPanel);
            app.ShowLabel.HorizontalAlignment = 'right';
            app.ShowLabel.Position = [56 23 39 22];
            app.ShowLabel.Text = 'Show:';

            % Create ShowDropDown
            app.ShowDropDown = uidropdown(app.StudyFieldPanel);
            app.ShowDropDown.Items = {'Tension signal', 'Mean values'};
            app.ShowDropDown.Position = [110 23 115 22];
            app.ShowDropDown.Value = 'Tension signal';

            % Create PrintButton
            app.PrintButton = uibutton(app.MIAnalysisUIFigure, 'push');
            app.PrintButton.ButtonPushedFcn = createCallbackFcn(app, @PrintButtonPushed, true);
            app.PrintButton.Position = [51 220 100 22];
            app.PrintButton.Text = 'Print';

            % Show the figure after all components are created
            app.MIAnalysisUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = analysis

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MIAnalysisUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MIAnalysisUIFigure)
        end
    end
end