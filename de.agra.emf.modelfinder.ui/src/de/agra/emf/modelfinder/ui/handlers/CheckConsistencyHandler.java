package de.agra.emf.modelfinder.ui.handlers;

import de.agra.emf.modelfinder.ui.utils.ResourceLoader;
import de.agra.emf.modelfinder.ui.dialogs.BoundsDialog;
import de.agra.emf.modelfinder.stategenerator.NoOperationCallsDetermination;
import de.agra.emf.modelfinder.stategenerator.StateGenerator;
import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.swt.SWT;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.handlers.HandlerUtil;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;

/**
 * Our sample handler extends AbstractHandler, an IHandler base class.
 * @see org.eclipse.core.commands.IHandler
 * @see org.eclipse.core.commands.AbstractHandler
 */
public class CheckConsistencyHandler extends AbstractHandler {
    /**
     * The constructor.
     */
    public CheckConsistencyHandler() {
    }

    /**
     * the command has been executed, so extract extract the needed information
     * from the application context.
     */
    public Object execute(ExecutionEvent event) throws ExecutionException {
        IWorkbenchWindow window = HandlerUtil.getActiveWorkbenchWindowChecked(event);
        ISelection selection = window.getSelectionService().getSelection();
        
        // get the selected file (if any)
        if (selection instanceof IStructuredSelection) {
            IStructuredSelection ssel = (IStructuredSelection) selection;
            Object obj = ssel.getFirstElement();
            IFile file = (IFile) Platform.getAdapterManager().getAdapter(obj,
                    IFile.class);
            if (file == null) {
                if (obj instanceof IAdaptable) {
                    file = (IFile) ((IAdaptable) obj).getAdapter(IFile.class);
                }
            }
            if (file != null) {
                // do something                          
                String loc = file.getFullPath().toOSString();
                try {
                    EPackage ep = ResourceLoader.loadResource(loc);
                    StateGenerator sg = new StateGenerator(ep);
                    BoundsDialog dialog = new BoundsDialog(window.getShell(), ep);
                    int returnCode = dialog.open();
                    if (returnCode == SWT.OK){
                        sg.generate(dialog.getBounds(), new NoOperationCallsDetermination());
                    }
                } catch (Exception e) {
                    MessageDialog.openError(window.getShell(),
                            "Modelfinder UI",
                            "Could not read meta model from file.\n" + e.getMessage());                                    
                }
            } else {
                MessageDialog.openError(window.getShell(),
                        "Modelfinder UI",
                        "No meta model file selected.");            
            }
        }
        
        return null;
    }
}
