import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

import java.text.BreakIterator;

import java.util.*;

import CLIPSJNI.*;

/* Implement FindFact which returns just a FactAddressValue or null */
/* TBD Add size method to PrimitiveValue */

/*

Notes:

This example creates just a single environment. If you create multiple environments,
call the destroy method when you no longer need the environment. This will free the
C data structures associated with the environment.

   clips = new Environment();
      .
      .
      .
   clips.destroy();

Calling the clear, reset, load, loadFacts, run, eval, build, assertString,
and makeInstance methods can trigger CLIPS garbage collection. If you need
to retain access to a PrimitiveValue returned by a prior eval, assertString,
or makeInstance call, retain it and then release it after the call is made.

   PrimitiveValue pv1 = clips.eval("(myFunction foo)");
   pv1.retain();
   PrimitiveValue pv2 = clips.eval("(myFunction bar)");
      .
      .
      .
   pv1.release();

*/

class Phone implements ActionListener
{
    JLabel displayLabel;
    JButton nextButton;
    JPanel choicesPanel;
    ButtonGroup choicesButtons;
    ResourceBundle phoneResources;

    Environment clips;
    boolean isExecuting = false;
    Thread executionThread;

    Phone()
    {
        try
        {
            phoneResources = ResourceBundle.getBundle("resources.phoneResources",Locale.getDefault());
        }
        catch (MissingResourceException mre)
        {
            mre.printStackTrace();
            return;
        }

        /*================================*/
        /* Create a new JFrame container. */
        /*================================*/

        JFrame jfrm = new JFrame(phoneResources.getString("Phone"));

        /*=============================*/
        /* Specify FlowLayout manager. */
        /*=============================*/

        jfrm.getContentPane().setLayout(new GridLayout(3,1));

        /*=================================*/
        /* Give the frame an initial size. */
        /*=================================*/

        jfrm.setSize(350,200);

        /*=============================================================*/
        /* Terminate the program when the user closes the application. */
        /*=============================================================*/

        jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        /*===========================*/
        /* Create the display panel. */
        /*===========================*/

        JPanel displayPanel = new JPanel();
        displayLabel = new JLabel();
        displayPanel.add(displayLabel);

        /*===========================*/
        /* Create the choices panel. */
        /*===========================*/

        choicesPanel = new JPanel();
        choicesButtons = new ButtonGroup();

        /*===========================*/
        /* Create the buttons panel. */
        /*===========================*/

        JPanel buttonPanel = new JPanel();

        nextButton = new JButton(phoneResources.getString("Next"));
        nextButton.setActionCommand("Next");
        buttonPanel.add(nextButton);
        nextButton.addActionListener(this);

        /*=====================================*/
        /* Add the panels to the content pane. */
        /*=====================================*/

        jfrm.getContentPane().add(displayPanel);
        jfrm.getContentPane().add(choicesPanel);
        jfrm.getContentPane().add(buttonPanel);

        /*========================*/
        /* Load the phone program. */
        /*========================*/

        clips = new Environment();

        clips.load("phone.clp");

        clips.reset();
        runPhone();

        /*====================*/
        /* Display the frame. */
        /*====================*/

        jfrm.setVisible(true);
    }

    /****************/
    /* nextUIState: */
    /****************/
    private void nextUIState() throws Exception
    {
        /*=====================*/
        /* Get the state-list. */
        /*=====================*/

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        /*===========================*/
        /* Get the current UI state. */
        /*===========================*/

        evalStr = "(find-all-facts ((?f UI-state)) " +
                "(eq ?f:id " + currentID + "))";

        PrimitiveValue fv = clips.eval(evalStr).get(0);

        /*========================================*/
        /* Determine the Next button state. */
        /*========================================*/

        if (fv.getFactSlot("state").toString().equals("final"))
        {
            nextButton.setActionCommand("Restart");
            nextButton.setText(phoneResources.getString("Restart"));
        }
        else if (fv.getFactSlot("state").toString().equals("initial"))
        {
            nextButton.setActionCommand("Next");
            nextButton.setText(phoneResources.getString("Next"));
        }
        else
        {
            nextButton.setActionCommand("Next");
            nextButton.setText(phoneResources.getString("Next"));
        }

        /*=====================*/
        /* Set up the choices. */
        /*=====================*/

        choicesPanel.removeAll();
        choicesButtons = new ButtonGroup();

        PrimitiveValue pv = fv.getFactSlot("valid-answers");

        String selected = fv.getFactSlot("response").toString();

        for (int i = 0; i < pv.size(); i++)
        {
            PrimitiveValue bv = pv.get(i);
            JRadioButton rButton;

            if (bv.toString().equals(selected))
            { rButton = new JRadioButton(phoneResources.getString(bv.toString()),true); }
            else
            { rButton = new JRadioButton(phoneResources.getString(bv.toString()),false); }

            rButton.setActionCommand(bv.toString());
            choicesPanel.add(rButton);
            choicesButtons.add(rButton);
        }

        choicesPanel.repaint();

        /*====================================*/
        /* Set the label to the display text. */
        /*====================================*/

        String theText = phoneResources.getString(fv.getFactSlot("display").symbolValue());

        wrapLabelText(displayLabel,theText);

        executionThread = null;

        isExecuting = false;
    }

    /*########################*/
    /* ActionListener Methods */
    /*########################*/

    /*******************/
    /* actionPerformed */
    /*******************/
    public void actionPerformed(
            ActionEvent ae)
    {
        try
        { onActionPerformed(ae); }
        catch (Exception e)
        { e.printStackTrace(); }
    }

    /***********/
    /* runPhone */
    /***********/
    public void runPhone()
    {
        Runnable runThread =
                new Runnable()
                {
                    public void run()
                    {
                        clips.run();

                        SwingUtilities.invokeLater(
                                new Runnable()
                                {
                                    public void run()
                                    {
                                        try
                                        { nextUIState();
                                          logCLIPSInfo();}
                                        catch (Exception e)
                                        { e.printStackTrace(); }
                                    }
                                });
                    }
                };

        isExecuting = true;

        executionThread = new Thread(runThread);

        executionThread.start();
    }

    /*********************/
    /* onActionPerformed */
    /*********************/
    public void onActionPerformed(
            ActionEvent ae) throws Exception
    {
        if (isExecuting) return;

        /*=====================*/
        /* Get the state-list. */
        /*=====================*/

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        /*=========================*/
        /* Handle the Next button. */
        /*=========================*/

        if (ae.getActionCommand().equals("Next"))
        {
            if (choicesButtons.getButtonCount() == 0)
            { clips.assertString("(next " + currentID + ")"); }
            else
            {
                clips.assertString("(next " + currentID + " " +
                        choicesButtons.getSelection().getActionCommand() +
                        ")");
            }

            runPhone();
        }
        else if (ae.getActionCommand().equals("Restart"))
        {
            clips.reset();
            runPhone();
        }
    }

    /*****************/
    /* wrapLabelText */
    /*****************/
    private void wrapLabelText(
            JLabel label,
            String text)
    {
        FontMetrics fm = label.getFontMetrics(label.getFont());
        Container container = label.getParent();
        int containerWidth = container.getWidth();
        int textWidth = SwingUtilities.computeStringWidth(fm,text);
        int desiredWidth;

        if (textWidth <= containerWidth)
        { desiredWidth = containerWidth; }
        else
        {
            int lines = (int) ((textWidth + containerWidth) / containerWidth);

            desiredWidth = (int) (textWidth / lines);
        }

        BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        StringBuffer trial = new StringBuffer();
        StringBuffer real = new StringBuffer("<html><center>");

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE;
             start = end, end = boundary.next())
        {
            String word = text.substring(start,end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm,trial.toString());
            if (trialWidth > containerWidth)
            {
                trial = new StringBuffer(word);
                real.append("<br>");
                real.append(word);
            }
            else if (trialWidth > desiredWidth)
            {
                trial = new StringBuffer("");
                real.append(word);
                real.append("<br>");
            }
            else
            { real.append(word); }
        }

        real.append("</html>");

        label.setText(real.toString());
    }

    public static void main(String args[])
    {
        // Create the frame on the event dispatching thread.
        SwingUtilities.invokeLater(
                new Runnable()
                {
                    public void run() { new Phone(); }
                });
    }

    /*******************/
    /* logCLIPSInfo */
    /*******************/
    public void logCLIPSInfo() {
        PrimitiveValue executionInfo = clips.eval("(facts)");

        System.out.println("CLIPS Execution Info:");
        System.out.println(executionInfo.toString());
    }

}