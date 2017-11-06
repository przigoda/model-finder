package de.agra.emf.modelfinder.ui.dialogs

import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EPackage
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Spinner

class BoundsDialog extends Dialog {
    val EPackage model;
    val Map<String, Spinner> minSpin;
    val Map<String, Spinner> maxSpin; 
    
    public new(Shell parentShell, EPackage model) {
        super(parentShell)
        this.model = model
        this.minSpin = new HashMap
        this.maxSpin = new HashMap
    }
    
    def getBounds() {
        val bounds = new HashMap<String, Pair<Integer, Integer>>
        for (cls: model.EClassifiers){
            val name = cls.getName
            val min = new Integer(minSpin.get(name).text)
            val max = new Integer(maxSpin.get(name).text)
            bounds.put(name, new Pair(min, max))
        }
        new IntervalBounds(model, bounds)
    }

    override Control createDialogArea(Composite parent){
        val composite = super.createDialogArea(parent) as Composite
        val layout = new GridLayout
        layout.numColumns = 3
        composite.setLayout(layout)
        val clabel = new Label(composite, SWT::BORDER)
        clabel.setText("Class")
        val minlabel = new Label(composite, SWT::BORDER)
        minlabel.setText("Min.")
        val maxlabel = new Label(composite, SWT::BORDER)
        maxlabel.setText("Max.")
        
        val classifiers = model.getEClassifiers
        for (cls: classifiers){
            val name = cls.getName
            val label = new Label(composite, SWT::BORDER)
            label.setText(name)
            val minSpinner = new Spinner(composite, SWT::BORDER)
            minSpinner.setMinimum(0)
            minSpinner.setMaximum(1000)            
            val maxSpinner = new Spinner(composite, SWT::BORDER)
            maxSpinner.setMinimum(0)
            maxSpinner.setMaximum(1000)            
            minSpin.put(name, minSpinner)
            maxSpin.put(name, maxSpinner)
        }        
        return composite
    }  


}